import 'package:auth_link_app/common/provider_id.dart';
import 'package:auth_link_app/provider/google_user_provider.dart';
import 'package:auth_link_app/provider/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  UserProvider userProvider;
  GoogleUserProvider googleUserProvider;

  @override
  void initState() {
    super.initState();
    userProvider = Provider.of<UserProvider>(context, listen: false);
    googleUserProvider = Provider.of<GoogleUserProvider>(context, listen: false);
  }

  @override
  Widget build(BuildContext context) {
    var user = Provider.of<UserProvider>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
      ),
      body: Consumer<UserProvider>(builder: (context, data, _) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              buildInfo(label: 'Current User', value: data.user?.email),
              buildInfo(label: 'Email verified', value: data.user.emailVerified ? "Verified" : "Not Verified"),
              ElevatedButton(
                onPressed: () async {
                  await data.sendEmailVerification().onError((error, stackTrace) {
                    EasyLoading.showError("$error");
                  });
                },
                child: Text('Verify Email'),
              ),
              buildInfo(label: 'No Telp', value: '${data.user.phoneNumber ?? "-"}'),
              ElevatedButton(
                onPressed: () async {
                  if (data.user.phoneNumber != null && data.user.phoneNumber.isNotEmpty) {
                    showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: Text('Already Linked'),
                            content: Text('Unlink Phone Number?'),
                            actions: [
                              ElevatedButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: Text('Kembali')),
                              ElevatedButton(
                                  onPressed: () async {
                                    await data.unlinkCredential(authProviderID: AuthProviderID.phone);
                                    Navigator.pop(context);
                                  },
                                  style: ElevatedButton.styleFrom(
                                    primary: Colors.redAccent,
                                  ),
                                  child: Text('Unlink')),
                            ],
                          );
                        });
                  } else {
                    TextEditingController phoneNumber = TextEditingController();
                    await showDialog(
                        context: context,
                        barrierDismissible: false,
                        builder: (context) {
                          return AlertDialog(
                            title: Text('Masukkan Nomor Telepon'),
                            content: Row(
                              children: [
                                Text('+62 '),
                                Expanded(
                                  child: TextField(
                                    keyboardType: TextInputType.phone,
                                    controller: phoneNumber,
                                  ),
                                ),
                              ],
                            ),
                            actions: [
                              ElevatedButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  style: ElevatedButton.styleFrom(
                                    primary: Colors.grey,
                                  ),
                                  child: Text('Kembali')),
                              ElevatedButton(
                                  onPressed: () async {
                                    Navigator.pop(context, phoneNumber.text);
                                  },
                                  child: Text('Verifikasi')),
                            ],
                          );
                        }).then((value) {
                      if (value != null) {
                        data.addPhoneNumber(context, "+62 $value");
                      }
                    });
                  }
                },
                child: Text('Add Phone Number'),
              ),
              Divider(),
              buildInfo(label: "Link to Google", value: "${data.getProviderData(authProviderID: AuthProviderID.google)?.email ?? "Not Linked"}"),
              GestureDetector(
                onTap: () async {
                  if (data.getProviderData(authProviderID: AuthProviderID.google) != null) {
                    showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: Text('Already Linked'),
                            content: Text('Unlink Google?'),
                            actions: [
                              ElevatedButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: Text('Kembali')),
                              ElevatedButton(
                                  onPressed: () async {
                                    await data.unlinkCredential(authProviderID: AuthProviderID.google);
                                    Navigator.pop(context);
                                  },
                                  style: ElevatedButton.styleFrom(
                                    primary: Colors.redAccent,
                                  ),
                                  child: Text('Unlink')),
                            ],
                          );
                        });
                  } else {
                    await data.linkCredential(authCredential: await googleUserProvider.signIn());
                  }
                },
                child: Container(
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(4)),
                  ),
                  child: Image(
                    image: AssetImage('assets/images/google.png'),
                    width: 24,
                  ),
                ),
              ),
            ],
          ),
        );
      }),
      bottomNavigationBar: ElevatedButton(
        style: ElevatedButton.styleFrom(
          primary: Colors.redAccent,
        ),
        onPressed: () async {
          await user.signOut();
          await Navigator.popAndPushNamed(context, "/login");
        },
        child: Text("Sign out"),
      ),
    );
  }

  Widget buildInfo({String label, String value}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '${label ?? ''}',
          ),
          Text(
            '${value ?? ''}',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
