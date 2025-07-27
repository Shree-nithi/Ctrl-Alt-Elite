import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My Server App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: ServerConnectorPage(serverUrl: 'https://hack.eqasonline.com'),
    );
  }
}

class ServerConnectorPage extends StatefulWidget {
  final String serverUrl;

  ServerConnectorPage({required this.serverUrl});

  @override
  _ServerConnectorPageState createState() => _ServerConnectorPageState();
}

class _ServerConnectorPageState extends State<ServerConnectorPage> {
  String _status = 'Not connected';
  bool _isConnecting = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Server App'),
      ),
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.cloud,
                size: 64,
                color: _status == 'Connected' ? Colors.green : Colors.grey,
              ),
              SizedBox(height: 16),
              Text(
                'Server: ${widget.serverUrl}',
                style: Theme.of(context).textTheme.headlineSmall,
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 16),
              Text(
                _status,
                style: TextStyle(
                  fontSize: 18,
                  color: _status == 'Connected' ? Colors.green : Colors.red,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 32),
              ElevatedButton.icon(
                onPressed: _isConnecting ? null : _connectToServer,
                icon: _isConnecting 
                  ? SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : Icon(Icons.refresh),
                label: Text(_isConnecting ? 'Connecting...' : 'Connect to Server'),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _connectToServer() async {
    setState(() {
      _isConnecting = true;
      _status = 'Connecting...';
    });

    try {
      final response = await http.get(
        Uri.parse(widget.serverUrl),
        headers: {'Content-Type': 'application/json'},
      ).timeout(Duration(seconds: 10));

      if (response.statusCode == 200) {
        setState(() {
          _status = 'Connected';
        });
      } else {
        setState(() {
          _status = 'Connection failed (Status: ${response.statusCode})';
        });
      }
    } catch (e) {
      setState(() {
        _status = 'Connection failed: $e';
      });
    } finally {
      setState(() {
        _isConnecting = false;
      });
    }
  }
}