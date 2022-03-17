import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../widgets/main_drawer.dart';

class FiltersScreen extends StatefulWidget {
  static const routeName = '/filters';
  const FiltersScreen({Key? key}) : super(key: key);

  @override
  State<FiltersScreen> createState() => _FiltersScreenState();
}

class _FiltersScreenState extends State<FiltersScreen> {
  late TextEditingController _searchStringController = TextEditingController();

  String fieldValue = 'Tài chính - ngân hàng';
  int statusIndex = 0;
  static const fields = [
    "Tài chính - ngân hàng",
    "Khoa học - công nghệ",
    "Nông nghiệp xanh",
    "Công nghệ hoá-sinh",
    "Dịch vụ",
    "Du lịch",
    "Giáo dục",
    "Y tế",
    "Công nghiẹp chế tạo, sản xuất",
  ];

  static const statuses = [
    {
      "value": -1,
      "color": Colors.orange,
      "description": "Đang chờ duyệt",
    },
    {
      "value": 0,
      "color": Colors.green,
      "description": "Đang hoạt động",
    },
    {
      "value": 1,
      "color": Colors.red,
      "description": "Ngừng hoạt động",
    },
    {
      "value": 2,
      "color": Colors.black,
      "description": "Ngừng tuyển",
    },
  ];

  @override
  Widget build(BuildContext context) {
    SharedPreferences sharedPreferences;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your filters'),
        actions: <Widget>[
          IconButton(
            onPressed: () async => {
              sharedPreferences = await SharedPreferences.getInstance(),
              sharedPreferences.setString("status", statusIndex.toString()),
              sharedPreferences.setString("field", fieldValue),
              sharedPreferences.setString("searchString", _searchStringController.text),
              popupMessage(context, "Filter", "Apply successfull!")
            },
            icon: const Icon(Icons.save),
          ),
          IconButton(
            onPressed: () async => {
              sharedPreferences = await SharedPreferences.getInstance(),
              sharedPreferences.remove("status"),
              sharedPreferences.remove("field"),
              sharedPreferences.remove("searchString"),
              popupMessage(context, "Filter", "Remove successfull!")
            },
            icon: const Icon(Icons.delete, color: Colors.red),
          )
        ],
      ),
      drawer: const MainDrawer(),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 20.0),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: <Widget>[
          const Text(
            "Đề tài dự án",
            style: TextStyle(color: Colors.black, fontSize: 20.0, fontWeight: FontWeight.bold),
            textAlign: TextAlign.left,
          ),
          TextFormField(
            controller: _searchStringController,
            cursorColor: Colors.black,
            style: const TextStyle(color: Colors.black),
            decoration: const InputDecoration(
              border: UnderlineInputBorder(borderSide: BorderSide(color: Colors.black)),
              hintStyle: TextStyle(color: Colors.black),
            ),
          ),
          const SizedBox(height: 30.0),
          const Text(
            "Lĩnh vực",
            style: TextStyle(color: Colors.black, fontSize: 20.0, fontWeight: FontWeight.bold),
            textAlign: TextAlign.left,
          ),
          const SizedBox(height: 15.0),
          DropdownButton<String>(
            selectedItemBuilder: (BuildContext context) {
              return fields.map<Widget>((String item) {
                return Expanded(child: Text(item));
              }).toList();
            },
            value: fieldValue,
            icon: const Icon(Icons.arrow_downward),
            elevation: 16,
            style: TextStyle(color: Theme.of(context).primaryColor),
            underline: Container(
              height: 1,
              color: Theme.of(context).primaryColor,
            ),
            onChanged: (String? newValue) {
              setState(() {
                fieldValue = newValue!;
              });
            },
            items: fields.map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
          ),
          const SizedBox(height: 30.0),
          const Text(
            "Trạng thái",
            style: TextStyle(color: Colors.black, fontSize: 20.0, fontWeight: FontWeight.bold),
            textAlign: TextAlign.left,
          ),
          const SizedBox(height: 15.0),
          DropdownButton<int>(
            value: statusIndex,
            icon: const Icon(Icons.arrow_downward),
            elevation: 16,
            style: TextStyle(color: Theme.of(context).primaryColor),
            underline: Container(
              height: 1,
              color: Theme.of(context).primaryColor,
            ),
            onChanged: (int? index) {
              setState(() {
                statusIndex = index!;
              });
            },
            items: statuses.map<DropdownMenuItem<int>>((dynamic value) {
              return DropdownMenuItem<int>(
                value: value['value'] as int,
                child: Text(value['description'] as String),
              );
            }).toList(),
          ),
        ]),
      ),
    );
  }

  SwitchListTile buildSwitchListTile(
      String title, String subtitle, bool value, Function updateValue) {
    return SwitchListTile(
      title: Text(title),
      subtitle: Text(subtitle),
      value: value,
      onChanged: (value) {
        updateValue(value);
      },
    );
  }

  Future<void> popupMessage(BuildContext context, String title, String message) async {
    await showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }
}
