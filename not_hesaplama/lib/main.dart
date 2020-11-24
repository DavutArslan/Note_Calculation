import 'package:flutter/material.dart';

void main() {
  runApp(Main());
}

class Main extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Not hesaplama",
      theme: ThemeData(
        primaryColor: Colors.orange,
      ),
      home: MyhomePage(),
    );
  }
}

class MyhomePage extends StatefulWidget {
  @override
  _MyhomePageState createState() => _MyhomePageState();
}

class _MyhomePageState extends State<MyhomePage> {
  String _dersAdi;
  int dersKredileri = 1;
  double dersHarfNotlari = 4;
  double ortalama = 0;
  static int sayac = 0;

  var formKey = GlobalKey<FormState>();

  List<Ders> tumdersler;

  @override
  void initState() {
    super.initState();
    tumdersler = [];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.orange,
        child: Icon(
          Icons.add,
        ),
        onPressed: () {
          if (formKey.currentState.validate()) {
            formKey.currentState.save();
          }
        },
      ),
      appBar: AppBar(
        title: Text(
          'Not Hesaplama',
        ),
        centerTitle: true,
        //shadowColor: Colors.white,
      ),
      body: sayfaDuzeni(),
    );
  }

  Widget sayfaDuzeni() {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Container(
            margin: EdgeInsets.all(10),
            padding: EdgeInsets.all(10),
            color: Colors.white,
            child: Form(
                key: formKey,
                child: Column(
                  children: <Widget>[
                    TextFormField(
                      validator: (girilenDeger) {
                        if (girilenDeger.length > 0) {
                          return null;
                        } else
                          return "hatalı giriş yaptınız";
                      },
                      onSaved: (kaydedilenDeger) {
                        _dersAdi = kaydedilenDeger;
                        setState(() {
                          tumdersler.add(
                              Ders(_dersAdi, dersHarfNotlari, dersKredileri));
                          ortalama = 0;
                          ortalamaHesapla();
                        });
                      },
                      decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                            borderSide: BorderSide(color: Colors.orange),
                          ),
                          labelText: "Ders Adı",
                          labelStyle:
                              TextStyle(fontSize: 20, decorationThickness: 24),
                          hintText: "Lütfen Dersinizi giriniz"),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        Container(
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<int>(
                              dropdownColor: Colors.orange[100],
                              icon: Icon(Icons.add_box),
                              items: dersKredileriItems(),
                              onChanged: (secilenKredi) {
                                setState(
                                  () {
                                    dersKredileri = secilenKredi;
                                  },
                                );
                              },
                              value: dersKredileri,
                            ),
                          ),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.orange, width: 2),
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                          ),
                          padding: EdgeInsets.symmetric(
                            vertical: 10,
                            horizontal: 10,
                          ),
                          margin: EdgeInsets.only(top: 7),
                        ),
                        Container(
                          margin: EdgeInsets.only(top: 7),
                          padding: EdgeInsets.symmetric(
                            vertical: 10,
                            horizontal: 10,
                          ),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<double>(
                              dropdownColor: Colors.orange[100],
                              icon: Icon(
                                Icons.school,
                              ),
                              items: harfNotuItems(),
                              onChanged: (secilenHarfNotu) {
                                setState(
                                  () {
                                    dersHarfNotlari = secilenHarfNotu;
                                  },
                                );
                              },
                              value: dersHarfNotlari,
                            ),
                          ),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.orange, width: 2),
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                          ),
                        ),
                      ],
                    ),
                  ],
                )),
          ),
          Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.white, width: 2),
              borderRadius: BorderRadius.all(Radius.circular(10)),
            ),
            height: 70,
            margin: EdgeInsets.all(10),
            padding: EdgeInsets.all(10),
            child: Center(
              child: RichText(
                textAlign: TextAlign.center,
                text: TextSpan(children: [
                  TextSpan(
                      text: tumdersler.length == 0
                          ? "Lütfen Ders Ekleyiniz"
                          : "ORTALAMA:",
                      style: TextStyle(fontSize: 24, color: Colors.white)),
                  TextSpan(
                      text: tumdersler.length == 0
                          ? ""
                          : "${ortalama.toStringAsFixed(2)}",
                      style: TextStyle(fontSize: 36, color: Colors.white))
                ]),
              ),
            ),
          ),
          Expanded(
            child: Container(
              margin: EdgeInsets.all(10),
              padding: EdgeInsets.all(10),
              child: ListView.builder(
                itemBuilder: listeElemani,
                itemCount: tumdersler.length,
              ),
              color: Colors.white,
            ),
          ),
        ],
      ),
      color: Colors.orange,
    );
  }

  void ortalamaHesapla() {
    double toplamNot = 0;
    double toplamkredi = 0;
    for (var oankiDers in tumdersler) {
      var kredi = oankiDers.kredi;
      var harfdegeri = oankiDers.harfdegeri;

      toplamNot = toplamNot + (harfdegeri * kredi);
      toplamkredi = toplamkredi + kredi;
    }
    ortalama = toplamNot / toplamkredi;
  }

  Widget listeElemani(BuildContext context, int index) {
    sayac++;
    return Dismissible(
      key: Key(sayac.toString()),
      direction: DismissDirection.startToEnd,
      onDismissed: (direction) {
        setState(() {
          tumdersler.removeAt(index);
          ortalamaHesapla();
        });
      },
      child: Card(
        child: ListTile(
          title: Text(tumdersler[index].ad),
          subtitle: Text(
            tumdersler[index].kredi.toString() +
                "kredi Ders notu değeri:" +
                tumdersler[index].harfdegeri.toString(),
          ),
        ),
      ),
    );
  }

  harfNotuItems() {
    List<DropdownMenuItem<double>> harfNotu = [];
    harfNotu.add(DropdownMenuItem(
      child: Text(
        "AA",
        style: TextStyle(fontSize: 20),
      ),
      value: 4,
    ));
    harfNotu.add(DropdownMenuItem(
      child: Text(
        "BA",
        style: TextStyle(fontSize: 20),
      ),
      value: 3.5,
    ));
    harfNotu.add(DropdownMenuItem(
      child: Text(
        "BB",
        style: TextStyle(fontSize: 20),
      ),
      value: 3,
    ));
    harfNotu.add(DropdownMenuItem(
      child: Text(
        "CB",
        style: TextStyle(fontSize: 20),
      ),
      value: 2.5,
    ));
    harfNotu.add(DropdownMenuItem(
      child: Text(
        "CC",
        style: TextStyle(fontSize: 20),
      ),
      value: 2,
    ));
    harfNotu.add(DropdownMenuItem(
      child: Text(
        "DC",
        style: TextStyle(fontSize: 20),
      ),
      value: 1.5,
    ));
    harfNotu.add(DropdownMenuItem(
      child: Text(
        "DD",
        style: TextStyle(fontSize: 20),
      ),
      value: 1,
    ));
    harfNotu.add(DropdownMenuItem(
      child: Text(
        "FF",
        style: TextStyle(fontSize: 20),
      ),
      value: 0,
    ));
    return harfNotu;
  }

  dersKredileriItems() {
    List<DropdownMenuItem<int>> krediler = [];
    for (int i = 1; i <= 10; i++) {
      krediler.add(DropdownMenuItem<int>(
        child: Text(
          "$i kredi",
          style: TextStyle(fontSize: 20),
        ),
        value: i,
      ));
    }
    return krediler;
  }
}

class Ders {
  String ad;
  double harfdegeri;
  int kredi;

  Ders(this.ad, this.harfdegeri, this.kredi);
}
