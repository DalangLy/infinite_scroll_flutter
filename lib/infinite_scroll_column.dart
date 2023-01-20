import 'package:flutter/material.dart';

class InfiniteScrollColumn extends StatefulWidget {
  final List<Widget> children;
  final Function() onLoadMore;
  final Widget? loadingIndicator;
  const InfiniteScrollColumn({Key? key, required this.children, required this.onLoadMore, this.loadingIndicator,}) : super(key: key);

  @override
  State<InfiniteScrollColumn> createState() => _InfiniteScrollColumnState();
}

class _InfiniteScrollColumnState extends State<InfiniteScrollColumn> {

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
    return SingleChildScrollView(
      controller: _scrollController,
      physics: const BouncingScrollPhysics(
        parent: AlwaysScrollableScrollPhysics(),
      ),
      child: Column(
        children: widget.children..add(_showLoadingIndicator()),
      ),
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
