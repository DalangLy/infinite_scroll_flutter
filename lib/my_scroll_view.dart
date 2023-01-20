import 'package:flutter/material.dart';

class MyScrollView extends StatefulWidget {
  final int itemCount;
  final Widget Function(BuildContext context, int index) builder;
  final Function() onLoadMore;
  final Widget? loadingIndicator;
  const MyScrollView({Key? key, required this.itemCount, required this.builder, required this.onLoadMore, this.loadingIndicator}) : super(key: key);

  @override
  State<MyScrollView> createState() => _MyScrollViewState();
}

class _MyScrollViewState extends State<MyScrollView> {
  late final ScrollController _scrollController;

  @override
  void initState() {
    _scrollController = ScrollController();

    _scrollController.addListener(_scrollListener);

    super.initState();
  }

  bool _isLoadMore = false;

  void _scrollListener() async {
    final ScrollPosition scrollPosition = _scrollController.position;
    final double triggerFetchMoreSize = 0.9 * scrollPosition.maxScrollExtent;

    final bool isScrolledDown = scrollPosition.axisDirection == AxisDirection.down;
    if (isScrolledDown &&  scrollPosition.pixels > triggerFetchMoreSize) {
      if(_isLoadMore) return;
      _showLoading();
      await widget.onLoadMore();
      _hideLoading();
    }
  }

  void _showLoading(){
    setState(() {
      _isLoadMore = true;
    });
  }

  void _hideLoading(){
    setState(() {
      _isLoadMore = false;
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      controller: _scrollController,
      physics: const BouncingScrollPhysics(
        parent: AlwaysScrollableScrollPhysics(),
      ),
      itemCount: widget.itemCount+1,
      itemBuilder: (context, index) {
        if(index >= widget.itemCount){
          return _showLoadingIndicator();
        }
        return widget.builder(context, index);
      },
    );
  }

  Widget _showLoadingIndicator(){
    return _isLoadMore ? Padding(
      padding: const EdgeInsets.all(20),
      child: widget.loadingIndicator ?? const Center(
        child: CircularProgressIndicator(),
      ),
    ) : const SizedBox();
  }
}
