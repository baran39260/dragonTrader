import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'bitcoin_data_fetcher.dart';
import 'top_toolbar.dart';
import 'left_toolbar.dart';
import 'right_axis_bar.dart';
import 'bottom_axis_bar.dart';
import 'chart_area.dart';

class ChartPage extends StatefulWidget {
  @override
  _ChartPageState createState() => _ChartPageState();
}

class _ChartPageState extends State<ChartPage> {
  List<double> _prices = [];
  bool _isLoading = true;
  String _errorMessage = '';
  String _selectedTimeFrame = '30'; // Default to 30 days
  double _scaleY = 1.0;
  double _scaleX = 1.0;
  double _offsetX = 0.0;
  double _offsetY = 0.0;
  double _startDragX = 0.0;
  double _startDragY = 0.0;
  double _startOffsetX = 0.0;
  double _startOffsetY = 0.0;

  @override
  void initState() {
    super.initState();
    _fetchData(_selectedTimeFrame);
  }

  void _fetchData(String days) async {
    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });
    try {
      BitcoinDataFetcher fetcher = BitcoinDataFetcher();
      var prices = await fetcher.fetchData(days);
      print(prices); // Log prices for debugging
      setState(() {
        _prices = prices;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
        _isLoading = false;
      });
    }
  }

  void _onTimeFrameSelected(String days) {
    setState(() {
      _selectedTimeFrame = days;
    });
    _fetchData(days);
  }

  void _onScaleStart(ScaleStartDetails details) {
    _startDragX = details.focalPoint.dx;
    _startDragY = details.focalPoint.dy;
    _startOffsetX = _offsetX;
    _startOffsetY = _offsetY;
  }

  void _onScaleUpdate(ScaleUpdateDetails details) {
    setState(() {
      _scaleX *= details.scale;
      if (_scaleX < 0.5) _scaleX = 0.5; // Limit the minimum scaleX
      if (_scaleX > 3.0) _scaleX = 3.0; // Limit the maximum scaleX

      _offsetX = _startOffsetX + (details.focalPoint.dx - _startDragX);
      _offsetY = _startOffsetY + (details.focalPoint.dy - _startDragY);
    });
  }

  void _onVerticalScale(PointerSignalEvent pointerSignal) {
    if (pointerSignal is PointerScrollEvent) {
      setState(() {
        _scaleY += pointerSignal.scrollDelta.dy * -0.01;
        if (_scaleY < 0.5) _scaleY = 0.5;
        if (_scaleY > 3.0) _scaleY = 3.0;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          TopToolbar(
            onTimeFrameSelected: _onTimeFrameSelected,
            selectedTimeFrame: _selectedTimeFrame,
          ),
          // Main Content
          Expanded(
            child: Row(
              children: [
                LeftToolbar(),
                // Main Chart Area
                Expanded(
                  child: Stack(
                    children: [
                      _isLoading
                          ? Center(child: CircularProgressIndicator())
                          : _errorMessage.isNotEmpty
                          ? Center(child: Text(_errorMessage))
                          : ChartArea(
                        prices: _prices,
                        scaleY: _scaleY,
                        scaleX: _scaleX,
                        offsetX: _offsetX,
                        offsetY: _offsetY,
                        onScaleStart: _onScaleStart,
                        onScaleUpdate: _onScaleUpdate,
                      ),
                      // Floating Currency Info Bar
                      if (!_isLoading && _errorMessage.isEmpty)
                        Positioned(
                          top: 10,
                          left: 10,
                          right: 10,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    'BTC/USD',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18),
                                  ),
                                  SizedBox(width: 10),
                                  Text(
                                    'CoinGecko',
                                    style: TextStyle(color: Colors.grey[600]),
                                  ),
                                  SizedBox(width: 10),
                                  Text(
                                    '1D',
                                    style: TextStyle(color: Colors.grey[600]),
                                  ),
                                ],
                              ),
                              SizedBox(height: 10),
                              Row(
                                children: [
                                  Text(
                                    'H: ${_prices.isNotEmpty ? _prices.reduce((a, b) => a > b ? a : b).toStringAsFixed(2) : 'N/A'}',
                                    style: TextStyle(color: Colors.green),
                                  ),
                                  SizedBox(width: 10),
                                  Text(
                                    'L: ${_prices.isNotEmpty ? _prices.reduce((a, b) => a < b ? a : b).toStringAsFixed(2) : 'N/A'}',
                                    style: TextStyle(color: Colors.red),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
                ),
                RightAxisBar(
                  prices: _prices,
                  scaleY: _scaleY,
                  offsetY: _offsetY,
                  onVerticalScale: _onVerticalScale,
                ),
              ],
            ),
          ),
          BottomAxisBar(
            prices: _prices,
            scaleX: _scaleX,
            offsetX: _offsetX,
          ),
        ],
      ),
    );
  }
}
