import 'package:flutter/material.dart';
import '../../helpers/db_helper.dart';

class ConfigurationScreen extends StatefulWidget {
  const ConfigurationScreen({super.key});

  @override
  State<ConfigurationScreen> createState() => _ConfigurationScreenState();
}

class _ConfigurationScreenState extends State<ConfigurationScreen> {
  // HOST tab controllers
  final _hostIdController = TextEditingController();
  final _hostNameController = TextEditingController();
  final _aliasController = TextEditingController();
  final _networkController = TextEditingController();
  final _processId1Controller = TextEditingController();
  final _processId2Controller = TextEditingController();
  final _lineController = TextEditingController();

  // DATABASE tab controllers
  final _localDbPathController = TextEditingController();
  final _localDataSourceController = TextEditingController();
  final _localUserController = TextEditingController();
  final _localPasswordController = TextEditingController();
  final _localDbNameController = TextEditingController();

  final _remoteDbPathController = TextEditingController();
  final _remoteDataSourceController = TextEditingController();
  final _remoteUserController = TextEditingController();
  final _remotePasswordController = TextEditingController();
  final _remoteDbNameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadConfig();
  }

  Future<void> _loadConfig() async {
    _hostIdController.text = await DBHelper.getValue('hostId') ?? '';
    _hostNameController.text = await DBHelper.getValue('hostName') ?? '';
    _aliasController.text = await DBHelper.getValue('alias') ?? '';
    _networkController.text = await DBHelper.getValue('network') ?? '';
    _processId1Controller.text = await DBHelper.getValue('processId1') ?? '';
    _processId2Controller.text = await DBHelper.getValue('processId2') ?? '';
    _lineController.text = await DBHelper.getValue('line') ?? '';

    _localDbPathController.text = await DBHelper.getValue('localDbPath') ?? '';
    _localDataSourceController.text =
        await DBHelper.getValue('localDataSource') ?? '';
    _localUserController.text = await DBHelper.getValue('localUser') ?? '';
    _localPasswordController.text =
        await DBHelper.getValue('localPassword') ?? '';
    _localDbNameController.text = await DBHelper.getValue('localDbName') ?? '';

    _remoteDbPathController.text =
        await DBHelper.getValue('remoteDbPath') ?? '';
    _remoteDataSourceController.text =
        await DBHelper.getValue('remoteDataSource') ?? '';
    _remoteUserController.text = await DBHelper.getValue('remoteUser') ?? '';
    _remotePasswordController.text =
        await DBHelper.getValue('remotePassword') ?? '';
    _remoteDbNameController.text =
        await DBHelper.getValue('remoteDbName') ?? '';
  }

  Future<void> _saveConfig() async {
    try {
      await DBHelper.save('hostId', _hostIdController.text);
      await DBHelper.save('hostName', _hostNameController.text);
      await DBHelper.save('alias', _aliasController.text);
      await DBHelper.save('network', _networkController.text);
      await DBHelper.save('processId1', _processId1Controller.text);
      await DBHelper.save('processId2', _processId2Controller.text);
      await DBHelper.save('line', _lineController.text);

      await DBHelper.save('localDbPath', _localDbPathController.text);
      await DBHelper.save('localDataSource', _localDataSourceController.text);
      await DBHelper.save('localUser', _localUserController.text);
      await DBHelper.save('localPassword', _localPasswordController.text);
      await DBHelper.save('localDbName', _localDbNameController.text);

      await DBHelper.save('remoteDbPath', _remoteDbPathController.text);
      await DBHelper.save('remoteDataSource', _remoteDataSourceController.text);
      await DBHelper.save('remoteUser', _remoteUserController.text);
      await DBHelper.save('remotePassword', _remotePasswordController.text);
      await DBHelper.save('remoteDbName', _remoteDbNameController.text);

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('✅ Configuration saved successfully'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('❌ Failed to save configuration: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Widget buildTextField(String label, TextEditingController controller,
      {bool obscureText = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          SizedBox(width: 120, child: Text(label)),
          Expanded(
            child: TextField(
              controller: controller,
              obscureText: obscureText,
              decoration: InputDecoration(
                hintText: obscureText ? '••••••••' : 'Enter',
                filled: true,
                fillColor: Colors.white,
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: const Color(0xFFF9F9F9),
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.red),
            onPressed: () => Navigator.pop(context),
          ),
          centerTitle: true,
          title: const Text(
            'Setting : Edit',
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
          ),
          bottom: const TabBar(
            indicatorColor: Colors.red,
            labelColor: Colors.black,
            unselectedLabelColor: Colors.grey,
            tabs: [
              Tab(text: 'Host'),
              Tab(text: 'Database'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            ListView(
              padding: const EdgeInsets.all(16),
              children: [
                buildTextField("Host Id", _hostIdController),
                buildTextField("Name", _hostNameController),
                buildTextField("Alias", _aliasController),
                buildTextField("Network", _networkController),
                buildTextField("Process ID 1", _processId1Controller),
                buildTextField("Process ID 2", _processId2Controller),
                buildTextField("Line", _lineController),
              ],
            ),
            ListView(
              padding: const EdgeInsets.all(16),
              children: [
                buildTextField("Local DB Path", _localDbPathController),
                buildTextField("Data Source", _localDataSourceController),
                buildTextField("User ID", _localUserController),
                buildTextField("Password", _localPasswordController,
                    obscureText: true),
                buildTextField("DB Name", _localDbNameController),
                const Divider(height: 32),
                buildTextField("Remote DB Path", _remoteDbPathController),
                buildTextField("Data Source", _remoteDataSourceController),
                buildTextField("User ID", _remoteUserController),
                buildTextField("Password", _remotePasswordController,
                    obscureText: true),
                buildTextField("DB Name", _remoteDbNameController),
              ],
            ),
          ],
        ),
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.all(16),
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
              padding: const EdgeInsets.symmetric(vertical: 14),
            ),
            onPressed: _saveConfig,
            child: const Text(
              'SAVE',
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ),
    );
  }
}
