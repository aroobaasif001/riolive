import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../../../customwidgets/custom_gradient_button.dart';
import '../../../../../../customwidgets/customtext.dart';
class Faceauthenticationscreen extends StatelessWidget {
  const Faceauthenticationscreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFB6F2E3),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        centerTitle: true,
        title: const CustomText(
          "Authentication",
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFB6F2E3), Color(0xFFF2D6F9)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 60),
                CircleAvatar(
                  radius: 60,
                  backgroundColor: Colors.blue.shade100,
                  child: ClipOval(
                    child: Image.asset(
                      'assets/images/face_auth1.png',
                      width: 153,
                      height: 153,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                const CustomText(
                  "Please upload a clear photo of yourself first",
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                  textAlign: TextAlign.center,
                ),
                Divider(
                  thickness: 1,
                  color: Colors.black.withOpacity(0.08),
                ),
                const SizedBox(height: 5),
                Row(
                  children: [
                    Expanded(
                      child: _buildActionButton(
                        "Upload Picture",
                        'assets/images/face_auth2.png',
                      ),
                    ),
                    const SizedBox(width: 5,height: 20),
                    Expanded(
                      child: _buildActionButton(
                        "Selfie With your ID",
                        'assets/images/face_auth2.png',
                      ),
                    ),
                    const SizedBox(width: 1),
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.only(top: 10), // 👈 jitna neeche chahiye utna adjust karein
                        child: _buildActionButton(
                          "Upload your \nShort video",
                          'assets/images/face_auth2.png',
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 100),
                Column(
                  children: [
                    ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        shadowColor: Colors.transparent,
                        minimumSize: const Size(double.infinity, 50),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(24),
                          side: const BorderSide(
                            color: Color(0xFF9557F9),
                            width: 1.5,
                          ),
                        ),
                      ),
                      child: const CustomText(
                        "Upload a photo of yourself",
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF9055FA),
                      ),
                    ),
                    const SizedBox(height: 20),
                    CustomGradientButton(
                      text: "Start to Certificate",
                      width: 300,
                      height: 50,
                      fontWeight: FontWeight.bold,
                      borderRadius: 24,
                      onPressed: () {},
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildActionButton(String label, String imagePath) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Image.asset(
          imagePath,
          width: 50,
          height: 50,
          fit: BoxFit.cover,
        ),
        const SizedBox(height: 12),
        CustomText(
          label,
          fontSize: 10,
          fontWeight: FontWeight.w400,
          textAlign: TextAlign.center,
          color: Colors.black87,
          maxLines: 2,
          softWrap: true,
        ),
      ],
    );
  }
}
