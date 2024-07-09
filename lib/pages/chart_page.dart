import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import '../data/bitcoin_data_fetcher.dart';
import '../widgets/top_toolbar.dart';
import '../widgets/left_toolbar.dart';
import '../widgets/right_axis_bar.dart';
import '../widgets/bottom_axis_bar.dart';
import '../widgets/chart_area.dart';

class ChartPage extends StatefulWidget {
  @override
  _ChartPageState createState() => _ChartPageState();
}

class _ChartPageState extends State<ChartPage> {
  List<double> _prices = [];
  bool _isLoading = true;
  String _errorMessage = '';
  String _selectedTimeFrame = '30'; // Default to 30 days
  String _currency = 'BTC/USD';
  String _source = 'CoinGecko';
  String _timeFrame = '1D';
  double _highPrice = 0.0;
  double _lowPrice = 0.0;
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
      setState(() {
        _prices = prices;
        _highPrice = prices.reduce((a, b) => a > b ? a : b);
        _lowPrice = prices.reduce((a, b) => a < b ? a : b);
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
      _timeFrame = _convertDaysToTimeFrame(days);
    });
    _fetchData(days);
  }

  String _convertDaysToTimeFrame(String days) {
    switch (days) {
      case '1':
        return '1D';
      case '7':
        return '1W';
      case '30':
        return '1M';
      case '90':
        return '3M';
      case '180':
        return '6M';
      case '365':
        return '1Y';
      default:
        return '1D';
    }
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
      _scaleY *= details.scale;
      if (_scaleX < 0.5) _scaleX = 0.5; // Limit the minimum scaleX
      if (_scaleX > 3.0) _scaleX = 3.0; // Limit the maximum scaleX
      if (_scaleY < 0.5) _scaleY = 0.5; // Limit the minimum scaleY
      if (_scaleY > 3.0) _scaleY = 3.0; // Limit the maximum scaleY

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

  void _onChartPointerSignal(PointerSignalEvent pointerSignal) {
    if (pointerSignal is PointerScrollEvent) {
      setState(() {
        _scaleX += pointerSignal.scrollDelta.dy * -0.01;
        _scaleY += pointerSignal.scrollDelta.dy * -0.01;
        if (_scaleX < 0.5) _scaleX = 0.5;
        if (_scaleX > 3.0) _scaleX = 3.0;
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
          Expanded(
            child: ClipRect(
              child: Row(
                children: [
                  LeftToolbar(),
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
                          onPointerSignal: _onChartPointerSignal,
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
                                      _currency,
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18),
                                    ),
                                    SizedBox(width: 10),
                                    Text(
                                      _source,
                                      style: TextStyle(color: Colors.grey[600]),
                                    ),
                                    SizedBox(width: 10),
                                    Text(
                                      _timeFrame,
                                      style: TextStyle(color: Colors.grey[600]),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 10),
                                Row(
                                  children: [
                                    Text(
                                      'H: ${_highPrice.toStringAsFixed(2)}',
                                      style: TextStyle(color: Colors.green),
                                    ),
                                    SizedBox(width: 10),
                                    Text(
                                      'L: ${_lowPrice.toStringAsFixed(2)}',
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
