import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'bloc/home_bloc.dart';

class HomePage extends StatefulWidget {
  HomePage({
    Key key,
  }) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  HomeBloc _bloc;
  final List<String> _choices = [
    "Barcode",
    "Image labeling",
  ];

  @override
  void dispose() {
    _bloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: <Widget>[
          PopupMenuButton(
            onSelected: _onActionSelected,
            itemBuilder: (context) => _choices
                .map(
                  (item) => PopupMenuItem<String>(
                    value: item,
                    child: Text(item),
                  ),
                )
                .toList(),
          ),
        ],
      ),
      body: BlocProvider(
        create: (context) {
          _bloc = HomeBloc();
          return _bloc;
        },
        child: BlocBuilder<HomeBloc, HomeState>(
          builder: (context, state) {
            if (state is Error) {
              return Center(child: Text("ERROR, intente de nuevo"));
            } else if (state is Results) {
              return SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(
                      height: 24,
                      width: MediaQuery.of(context).size.width,
                    ),
                    Image.file(
                      state.chosenImage,
                      height: 150,
                      width: 150,
                      fit: BoxFit.cover,
                    ),
                    SizedBox(height: 24),
                    Padding(
                      padding: EdgeInsets.all(12.0),
                      child: Center(
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.black),
                            borderRadius: BorderRadius.all(
                              Radius.circular(5.0),
                            ),
                          ),
                          child: Text(state.result ?? "No hay results"),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }
            return Center(child: Text("Seleccione accion del menu superior"));
          },
        ),
      ),
    );
  }

  void _onActionSelected(String action) {
    if (action == "Barcode") {
      _bloc.add(ScanPicture(barcodeScan: true));
    } else if (action == "Image labeling") {
      _bloc.add(ScanPicture(barcodeScan: false));
    }
  }
}
