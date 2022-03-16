import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class ProfileApplication extends StatefulWidget {
  const ProfileApplication({Key? key}) : super(key: key);
  @override
  _ProfileApplicationState createState() => _ProfileApplicationState();
}

class _ProfileApplicationState extends State<ProfileApplication> {
 
  @override
  Widget build(BuildContext context) {
    return DataTable(
      columns: <DataColumn>[
        DataColumn(
          label: Text(
            'Project Name',
            style: TextStyle(fontStyle: FontStyle.italic),
          ),
        ),
        DataColumn(
          label: Text(
            'Status',
            style: TextStyle(fontStyle: FontStyle.italic),
          ),
        ),
        DataColumn(
          label: Text(
            'Actions',
            style: TextStyle(fontStyle: FontStyle.italic),
          ),
        ),
      ],
      rows:  <DataRow>[
        DataRow(
          cells: <DataCell>[
            DataCell(Text('Sarah')),
            DataCell(Text('Pending')),
            DataCell(
              Row(
                children: <Widget>[
                  IconButton(
                    icon: Icon(Icons.arrow_circle_right),
                    onPressed: () {},
                  ),
                  IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () {},
                  ),
                ],
              ),
            ),
          ],
        ),
        DataRow(
          cells: <DataCell>[
            DataCell(Text('Janine')),
            DataCell(Text('Pending')),
            DataCell(
              Row(
                children: <Widget>[
                  IconButton(
                    icon: Icon(Icons.arrow_circle_right),
                    onPressed: () {},
                  ),
                  IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () {},
                  ),
                ],
              ),
            ),
          ],
        ),
        DataRow(
          cells: <DataCell>[
            DataCell(Text('William')),
            DataCell(Text('Pending')),
            DataCell(
              Row(
                children: <Widget>[
                  IconButton(
                    icon: Icon(Icons.arrow_circle_right),
                    onPressed: () {},
                  ),
                  IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () {},
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}