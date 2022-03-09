import 'package:flutter/material.dart';

import '../widgets/main_drawer.dart';

class FiltersScreen extends StatefulWidget {
  static const routeName = '/filters';
  final Function saveFilters;
  final Map<String, bool> filters;
  const FiltersScreen({Key? key, required this.saveFilters, required this.filters})
      : super(key: key);

  @override
  State<FiltersScreen> createState() => _FiltersScreenState();
}

class _FiltersScreenState extends State<FiltersScreen> {
  late bool _gluten = false;
  late bool _lactose = false;
  late bool _vegetarian = false;
  late bool _vegan = false;

  @override
  void initState() {
    _gluten = widget.filters['gluten']!;
    _lactose = widget.filters['lactose']!;
    _vegetarian = widget.filters['vegetarian']!;
    _vegan = widget.filters['vegan']!;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your filters'),
        actions: <Widget>[
          IconButton(
              onPressed: () => {
                    widget.saveFilters({
                      'gluten': _gluten,
                      'lactose': _lactose,
                      'vegetarian': _vegetarian,
                      'vegan': _vegan,
                    })
                  },
              icon: const Icon(Icons.save))
        ],
      ),
      drawer: const MainDrawer(),
      body: Column(children: <Widget>[
        Container(
          padding: const EdgeInsets.all(20),
          child: Text(
            'Adjust your meals selection',
            style: Theme.of(context).textTheme.headline6,
          ),
        ),
        Expanded(
            child: ListView(children: <Widget>[
          buildSwitchListTile(
            'Gluten-free',
            'Only include gluten-free meals.',
            _gluten,
            (value) {
              setState(() {
                _gluten = value;
              });
            },
          ),
          buildSwitchListTile(
            'Lactose-free',
            'Only include Lactose-free meals.',
            _lactose,
            (value) {
              setState(() {
                _lactose = value;
              });
            },
          ),
          buildSwitchListTile(
            'Vegeterian',
            'Only include Vegeterian meals.',
            _vegetarian,
            (value) {
              setState(() {
                _vegetarian = value;
              });
            },
          ),
          buildSwitchListTile(
            'Vegan',
            'Only include Vegan meals.',
            _vegan,
            (value) {
              setState(() {
                _vegan = value;
              });
            },
          ),
        ]))
      ]),
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
}
