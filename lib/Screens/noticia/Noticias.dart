import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:smart/API/noticia.dart';
import 'package:smart/Models/noticia/Noticia.dart';
import 'package:smart/Widgets/Preview.dart';
import 'package:smart/services/alert.dart';

final storage = FlutterSecureStorage();

class NoticiasPage extends StatefulWidget {
  @override
  _NoticiasPageState createState() => _NoticiasPageState();
}

class _NoticiasPageState extends State<NoticiasPage> {
  bool _load = true;
  int CantidadCargada = 0;
  dynamic Usuario = null;
  int present = 0;
  bool _loadingMore = false;
  List<NoticiaModel> _noticias = [];
  String? _uat;

  final NoticiasServices _noticiasService = new NoticiasServices();

  @override
  initState() {
    super.initState();
    onInit();
    /* analytics.setCurrentScreen(screenName: "NoticiasPage"); */
  }

  Future<void> onInit() async {
    String? jason = await storage.read(key: "USER");
    Usuario = jsonDecode(jason!);
    NoticiasServices noticiasClass = NoticiasServices();
    //AlertPop.alert(context, body: Text(noticiasClass.novedades.length.toString()));
    _noticias =
        await noticiasClass.getNovedades(context, Usuario["UAT"], present);
    // if(_noticias == null){
    //   _noticias.clear();
    // }
    //   _noticias.addAll(await _noticiasService.getNovedades(context, Usuario["UAT"], present));
    setState(() {
      // CantidadCargada = _noticiasService.novedades.length;
      _load = false;
    });
  }

  void loadMore() {
    setState(() {
      present = _noticias.last.Id!;
      _load = true;
      onInit();
    });
  }

  @override
  Widget build(BuildContext context) {
    final GlobalKey<ScaffoldState> _scaffoldKey =
        new GlobalKey<ScaffoldState>();
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () => Navigator.of(context).pop(),
          ),
          centerTitle: true,
          iconTheme: IconThemeData(color: Colors.black),
          title: Text("Novedades"),
          backgroundColor: Colors.white,
          elevation: 0,
        ),
        backgroundColor: Colors.white,
        body: _load
            ? Center(
                child: Container(
                  child: CircularProgressIndicator(),
                ),
              )
            : _noticias == null
                ? Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height,
                    child: Column(
                      children: <Widget>[
                        Container(
                          height: 230,
                        ),
                        Icon(
                          Icons.warning,
                          color: Colors.black54,
                          size: 70,
                        ),
                        Container(
                          height: 10,
                        ),
                        Text(
                          "No se encontraron Noticias",
                          style: TextStyle(color: Colors.black54, fontSize: 18),
                        )
                      ],
                    ),
                  )
                : RefreshIndicator(
                    onRefresh: onInit,
                    child: Padding(
                      padding: const EdgeInsets.all(15),
                      child: ListView.builder(
                          padding: const EdgeInsets.all(8),
                          itemCount: _noticias.length + 1,
                          itemBuilder: (context, index) {
                            if (index == _noticias.length) {
                              return CantidadCargada == 3
                                  ? Container(
                                      padding: const EdgeInsets.all(8),
                                      width: MediaQuery.of(context).size.width,
                                      height: 80,
                                      child: GestureDetector(
                                        onTap: loadMore,
                                        child: Card(
                                          color: Colors.blueAccent,
                                          clipBehavior:
                                              Clip.antiAliasWithSaveLayer,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                          child: Container(
                                            padding: const EdgeInsets.all(15),
                                            child: const Center(
                                              child: Text(
                                                "Cargar mas",
                                                style: TextStyle(
                                                    color: Colors.white),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    )
                                  : Container();
                            } else {
                              return Padding(
                                padding:
                                    const EdgeInsets.only(top: 10, bottom: 10),
                                child: NoticiaPreview(
                                  noticia: _noticias[index],
                                ),
                              );
                            }
                          }),
                    ),
                  ),
      ),
    );
  }
}
