import 'package:flutter/material.dart';
import 'package:ghargharmadoctor/api/api_bloc.dart';
import 'package:ghargharmadoctor/screens/User/side%20navigation/GdStore/StoreUtils/allProductListWidget.dart';
import 'package:ghargharmadoctor/screens/User/side%20navigation/GdStore/StoreUtils/latestProductWidget.dart';
import 'package:ghargharmadoctor/screens/User/side%20navigation/GdStore/StoreUtils/titleRow.dart';

class VendorAllProductsTabBarView extends StatefulWidget {
  const VendorAllProductsTabBarView({Key? key}) : super(key: key);

  @override
  State<VendorAllProductsTabBarView> createState() =>
      _VendorAllProductsTabBarViewState();
}

class _VendorAllProductsTabBarViewState
    extends State<VendorAllProductsTabBarView> {
  ScrollController? _scrollController;
  ApiHandlerBloc? productBloc;
  int page = 1;
  @override
  void initState() {
    productBloc = ApiHandlerBloc();
    productBloc!.fetchAPIList('products?vendor_type=&vendor_id=1&page=$page');

    super.initState();
    _scrollController = ScrollController()..addListener(_loadMore);
  }

  void _loadMore() async {
    print('hello ${_scrollController!.position.extentAfter}');
    if (_scrollController!.offset >=
            _scrollController!.position.maxScrollExtent &&
        !_scrollController!.position.outOfRange) {
      page += 1;
      // productBloc!.fetchAPIList('products');
      // stateBloc!.storeData(_scrollController!.position.extentAfter);
      // productBloc!.fetchAPIList('products?page=$page');
      // setState(() {});

      print('true');
    } else {
      print('flase');
    }
    // if (_hasNextPage == true &&
    //     _isFirstLoadRunning == false &&
    //     _isLoadMoreRunning == false &&
    //     _controller!.position.extentAfter < 300) {
    //   setState(() {
    //     _isLoadMoreRunning = true; // Display a progress indicator at the bottom
    //   });
    //   _page += 1; // Increase _page by 1
    //   if (_posts.isNotEmpty) {
    //     fetchData();
    //     // setState(() {
    //     //   _posts.addAll(randomAPIModel);
    //     // });
    //   } else {
    //     // This means there is no more data
    //     // and therefore, we will not send another GET request
    //     setState(() {
    //       _hasNextPage = false;
    //     });
    //   }
    //   // fetchData();
    //   setState(() {
    //     _isLoadMoreRunning = false;
    //   });
    // }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      controller: _scrollController,
      physics: const BouncingScrollPhysics(),
      child: Column(
        children: [
          titleCard('Latest Products', 'See All', () {}),
          latestProductWidget(context, '', 1, setState),
          titleCard('All Products', 'See All', () {}),
          allProductListWidget(context, '', 1),
        ],
      ),
    );
  }
}
