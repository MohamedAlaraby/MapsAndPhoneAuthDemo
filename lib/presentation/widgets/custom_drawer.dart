import '../../business_logic/phone_auth/phone_auth_cubit.dart';
import '../../constants/my_colors.dart';
import '../../constants/my_strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class MyDrawer extends StatelessWidget {
  MyDrawer({super.key});
  var cubit = PhoneAuthCubit();
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        child: ListView(
          children: [
            Container(
              height: 280,
              child: DrawerHeader(
                decoration: BoxDecoration(
                  color: Colors.blue[100],
                ),
                child: _buildDrawerHeader(context),
              ),
            ),
            _buildDrawerListItem(
                leadingIcon: Icons.person, title: "My Profile"),
            _buildDividerWidget(),
            _buildDrawerListItem(
                leadingIcon: Icons.history,
                title: "Places History",
                onTap: () {}),
            _buildDividerWidget(),
            _buildDrawerListItem(
                leadingIcon: Icons.settings, title: "Settings"),
            _buildDividerWidget(),
            _buildDrawerListItem(leadingIcon: Icons.help, title: "Help"),
            _buildLogoutWidget(context),
            const SizedBox(
              height: 30,
            ),
            ListTile(
              leading: Text(
                "Follow us",
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[600]),
              ),
            ),
            buildSocialMediaIcons(),
          ],
        ),
      ),
    );
  }

  Widget _buildLogoutWidget(context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.9,
      height: 50,
      child: BlocProvider<PhoneAuthCubit>(
        create: (context) => cubit,
        child: _buildDrawerListItem(
          leadingIcon: Icons.logout,
          title: "logout",
          onTap: () {
            cubit.signOut();
            Navigator.pushReplacementNamed(
              context,
              loginScreen,
            );
          },
          iconColor: Colors.red,
        ),
      ),
    );
  }

  Widget _buildDrawerHeader(BuildContext context) {
    return Container(
      decoration:
          BoxDecoration(color: Colors.blue[100], shape: BoxShape.rectangle),
      child: Column(
        children: [
          CircleAvatar(
            radius: 70,
            backgroundImage: Image.asset(
              "assets/images/mohamed.jpg",
              fit: BoxFit.cover,
            ).image,
          ),
          const SizedBox(
            height: 20,
          ),
          const Text(
            "Mohamed Elaraby",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          BlocProvider<PhoneAuthCubit>(
            create: (context) => cubit,
            child: Text(
              "${cubit.getLoggedInUser().phoneNumber}",
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDrawerListItem({
    required IconData leadingIcon,
    required String title,
    Widget? trailing,
    Function()? onTap,
    Color? iconColor,
  }) {
    return ListTile(
      leading: SizedBox(
        width: 50,
        height: 50,
        child: Icon(
          leadingIcon,
          color: iconColor ?? MyColors.blue,
        ),
      ),
      title: Text(title),
      trailing: trailing ??
          const Icon(
            Icons.arrow_right,
            color: MyColors.blue,
          ),
      onTap: onTap,
    );
  }

  Widget _buildDividerWidget() => const Divider(
        height: 0,
        thickness: 1,
        indent: 18,
        endIndent: 24,
      );

  void _lanuchUrl({required String url}) async {
    // ignore: deprecated_member_use
    await canLaunch(url) ? launch(url) : throw 'coundn\'t lanuch $url';
  }

  Widget buildSocialMediaIconsItem(IconData icon, String url) {
    return InkWell(
      onTap: () {
        _lanuchUrl(url: url);
      },
      child: Icon(
        icon,
        color: Colors.blue,
        size: 40,
      ),
    );
  }

  Widget buildSocialMediaIcons() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Expanded(
            child: buildSocialMediaIconsItem(FontAwesomeIcons.facebook,
                "https://www.facebook.com/mohamed.elflistine/"),
          ),
          Expanded(
            child: buildSocialMediaIconsItem(FontAwesomeIcons.linkedin,
                "https://www.linkedin.com/in/muhammed-elaraby-05b096169/"),
          ),
          Expanded(
            child: buildSocialMediaIconsItem(FontAwesomeIcons.youtube,
                "https://www.youtube.com/@mohamedelaraby631/featured"),
          ),
        ],
      ),
    );
  }
}
