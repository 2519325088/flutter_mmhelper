import 'package:flutter/material.dart';

class TCPage extends StatefulWidget {
  @override
  _TCPageState createState() => _TCPageState();
}

class _TCPageState extends State<TCPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.pink,
        title: Text(
          "T&C",
          style: TextStyle(
              color: Colors.white
          ),
        ),
        centerTitle: true,
      ),
      body: Container(
        padding:const EdgeInsets.all(10),
        child: ListView(
          children: <Widget>[
            Text(
              "Terms and Condition",
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.w800,
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Text(
              "By using this web site and mobile App, you are agreeing to be bound by these Terms and Conditions of Use, all applicable laws and regulations, and agree that you are responsible for compliance with any applicable local laws. If you do not agree with any of these terms, you are prohibited from using or accessing this site. The materials contained in this website are protected by applicable copyright and trade mark law.",
              style: TextStyle(
                fontSize: 18,
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Text(
              "Search4maid is an online platform that connects employers, domestic helpers and employment agencies.Our services and products are designed to facilitate with the posting, matching and hiring procedure for the 6 main helper categories listed. By signing up your log in information, information on job or helper profile posting, you enter into a legally binding agreement with Search4maid.",
              style: TextStyle(
                fontSize: 18,
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Text(
              "In these Terms and Conditions, the following terms shall have the respective meanings specified below unless the context otherwise requires:",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w800,
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.only(right: 10,left: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    "“Search4maid” means Search4maid.",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    "“Employer (s)” means user who places a job advertisement or promotes any job related activities via the Site.",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    "“Domestic Helper (s)” means users seeking employment.",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    "“Agency or Agencies” means users who place a job advertisement or any resumes on behalf an employment agency.",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    "“Site” means any websites, job portal or mobile application owned and operated by Search4maid and its affiliates/subsidiaries or its service providers.",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    "The terms “you”, “user” and “users” herein refer to all individuals and/or entities accessing and/or using the Site at any time for any reason or purpose.",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    "Search4maid is a platform where Employers and Domestic Helpers can connect and if needed employ the services of third party employment agencies.",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    "Search4maid is not an employment agency and we won’t proceed any official paperwork and don’t substitute to the mandatory need of a licensed employment agency for the creation and processing of any legal contract.",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                ],
              ),
            ),
            Text(
              "1. To use the Search4maid APP or website, you must be of minimum working age in the country where you are looking for jobs, and of minimum age for hiring in the country where you reside.",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w800,
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Text(
              "2. By agreement of the terms of service, you will be given the full permission allowing Search4maid to expose the information listed on the resume or job post, including personal details and mobile phone numbers. Search4maid will never disclose / expose your address on the mobile APP or website. The address will be used for personal mailing of contract or promotional material ONLY. All users are prohibited in using screen scraping, data mining, robots or similar data gathering and extraction tools on the Site for establishing, maintaining, advancing or reproducing information contained on our Site on your own website or in any other publication, except with our prior written consent.",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w800,
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Text(
              "3. The content of the pages of this APP or website is for your general information and use only. It is subject to change without notice.",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w800,
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Text(
              "4. To use this website, you may be asked to complete an online registration form. In consideration for your use of this website and the services provided on it, you agree to provide true, current, complete and accurate information. The materials appearing on Search4maid’s website and mobile App could include technical, typographical, or photographic errors. Search4maid does not warrant that any of the materials on its web site are accurate, complete, or current. Search4maid may make changes to the materials contained on its website at any time without notice. Search4maid does not, however, make any commitment to update the materials.",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w800,
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Text(
              "5. We keep the possibility to block any account, paying or not, if we suspect its owner of any disrespectful, illegal or dangerous intention. We will not redeem any fee charged for the creation and the management of this account.",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w800,
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Text(
              "6. Any fee potentially charged by the APP or website cannot be refunded.",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w800,
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Text(
              "7. Neither we nor any third parties provide any warranty or guarantee as to the accuracy, timeliness, performance, completeness or suitability of the information and materials found or offered on this APP or website for any particular purpose. You acknowledge that such information and materials may contain inaccuracies or errors and we expressly exclude liability for any such inaccuracies or errors to the fullest extent permitted by law.",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w800,
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Text(
              "8. Your use of any information or materials on this APP or website is entirely at your own risk, for which we shall not be liable. It shall be your own responsibility to ensure that any products, services or information available through this APP or website meet your specific requirements.",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w800,
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Text(
              "9. This APP or website contains material which is owned by or licensed to us. This material includes, but is not limited to, the design, layout, look, appearance and graphics. Reproduction is prohibited other than in accordance with the copyright notice, which forms part of these terms and conditions.",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w800,
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Text(
              "10. All trade marks reproduced in this APP or website which are not the property of, or licensed to, the operator are acknowledged on the APP or website.",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w800,
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Text(
              "11. Your use of this APP or website and any dispute arising out of such use of the APP or website is subject to the laws of HKSAR.",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w800,
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Text(
              "Use License",
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.w800,
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Text(
              "1. Permission is granted to temporarily use information on Search4maid’s web site for personal, non-commercial transitory viewing only. This is the grant of a license, not a transfer of title, and under this license you may not:",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w800,
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10,right: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    "1. modify or copy the materials;",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    "2. use the materials for any commercial purpose, or for any public display (commercial or non-commercial);",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    "3. attempt to decompile or reverse engineer any software contained on Search4maid’s web site;",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    "4. remove any copyright or other proprietary notations from the materials; or",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    "5. transfer the materials to another person or “mirror” the materials on any other server.",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                ],
              ),
            ),
            Text(
              "2. This license shall automatically terminate if you violate any of these restrictions and may be terminated by Search4maid at any time. Upon terminating your viewing of these materials or upon the termination of this license, you must destroy any downloaded materials in your possession whether in electronic or printed format.",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w800,
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Text(
              "Obligations",
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.w800,
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Text(
              "1. Search4maid is an online platform and we will NOT recommend applicant to anyone, we only provide an information platform for the users to get what they consider to be their best interest. Search4maid will not be responsible for any disputes after they have any transaction between themselves. You must read our Terms of Conditions and Privacy Policy and accept it before our services can be used.",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w800,
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Text(
              "2. You cannot use our services to send spam or unsolicited communication. You cannot ask any client to make a payment for any services. Search4maid reserves the right to suspend your services or reduce your user privileges.",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w800,
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Text(
              "3. You shall not request, wire or send money to other parties before reception of all mandatory documents. In case of monetary dispute with other users, Search4maid shall not be held responsible.",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w800,
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Text(
              "4. As a job seeker or employer, you have to provide accurate, correct and real information in all content you create (including ads, profile and private messages) and should there be changes, it should be updated at the APP. All users are fully responsible for any of the disclosed information. Do not disclose any information that you do not have the right to disclose. If there are any problems, we will reserve the right to sue. The materials appearing on Search4maid’s website and mobile App could include technical, typographical, or photographic errors. Search4maid does not warrant that any of the materials on its web site are accurate, complete, or current. Search4maid may make changes to the materials contained on its website at any time without notice. Search4maid does not, however, make any commitment to update the materials.",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w800,
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Text(
              "5. Your profile picture must include yourself and any other persons in the image should have given their permission. If you do not have permission of that person(s), you will be solely liable for any damages",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w800,
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Text(
              "6. You cannot impersonate another person or create a false identity. You can also not create a profile for anyone else than yourself. If you want to help friends, relatives, family or anyone else, you can introduce the services to them, but they will have to create their own profiles.",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w800,
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Text(
              "7. You are obliged to keep your own information save. Keep your username confidential, do not share passwords and take precautions to keep them save. Search4maid is not liable for any loss of personal information.",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w800,
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Text(
              "8. You must have ownership and authority of usage over the image you submit. No obscene, offensive, or adult images will be accepted. Any material which is knowingly false and/or defamatory, inaccurate, abusive, harassing, obscene, profane, sexually oriented, threatening, or otherwise violating any law will be deleted. Search4maid eserves the right to suspend any account should there be offensive content posted. The materials appearing on Search4maid’s website and mobile App could include technical, typographical, or photographic errors. Search4maid does not warrant that any of the materials on its web site are accurate, complete, or current. Search4maid may make changes to the materials contained on its website at any time without notice. Search4maid does not, however, make any commitment to update the materials.",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w800,
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Text(
              "9. You have to use the services in a professional matter and uphold this regardless of who you are contacting. Acting dishonestly will lead to your services being suspended and no refund will be offered.",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w800,
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Text(
              "10. You cannot share an account or profile. Any account can only be managed by one person and membership cannot be transferred to friends, family or whoever else.",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w800,
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Text(
              "11. You cannot market any goods, services or anything else in your private messages, your ad or profile page. We will take immediate action if we find that this obligation is violated.",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w800,
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Text(
              "12. You cannot copy profile or ad information of others through any means including the use of various technological tools or manually. If you are found to be selling any data or using it in your database, Search4maid will reserve the right to sue",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w800,
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Text(
              "13. You shall not violate the intellectual property or other rights of Search4maid, including, using the word “Search4maid” or our logos in any capacity unless given explicit written permission by Search4maid founder.",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w800,
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Text(
              "14. Employment agencies are not allowed to create helper nor employer accounts, unless with written request and has been permitted by Search4maid. If an employment agency creates such account, paying or not, we keep the possibility to block this account without notice and without refund.",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w800,
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Text(
              "Right",
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.w800,
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Text(
              "1. Search4maid may change, suspend or end any service or change and modify prices at our discretion. The prices of our services are subject to terms solely determined by Search4maid. No refund will be provided once the user has posted their info online.",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w800,
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Text(
              "2. Members, whether paying or unpaying, will be liable for uploading or giving any inaccurate, incomplete, misleading, offensive or illegal content. The materials appearing on Search4maid’s website and mobile App could include technical, typographical, or photographic errors. Search4maid does not warrant that any of the materials on its web site are accurate, complete, or current. Search4maid may make changes to the materials contained on its website at any time without notice. Search4maid does not, however, make any commitment to update the materials.",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w800,
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Text(
              "3. Search4maid is not liable for any content posted on a third party AD or App, and does not take any responsibility for the legal terms or privacy policies. You will agree to the user agreements of their services explicitly.",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w800,
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Text(
              "4. Search4maid may suspend, restrict or terminate your account if we find a breach or violation of any of our User Rights. In this case we will not redeem any fee charged for the creation and the management of this account.",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w800,
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Text(
              "5. For the recommended employment agencies or websites linked with us, it is your own decision on choice of application or usage. And you should bear any risk involved. We will not be responsible for any damage/ loss occurred. But we will try our best to make sure the linked websites and partner agencies are reliable.",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w800,
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Text(
              "6. Agencies and partners are independent from Search4maid. It is the agency or partner’s responsibility to make sure their communication with you complies with local regulations. If you decide to subscribe to a package with them, Search4maid is not responsible for any liability. You will have to sign a contract with the agency and communicate with them in case of disagreement.",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w800,
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Text(
              "7. Members may receive messages from other members about details in their profiles or be called by employers. Search4maid will not be responsible for any content of messages or phone calls",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w800,
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Text(
              "8. Search4maid reserves the right to change the content of our website and mobile APP at any time without advance notice.",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w800,
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Text(
              "Liabilities",
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.w800,
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Text(
              "1. The materials on Search4maid’s web site are provided “as is”. Search4maid makes no warranties, expressed or implied, and hereby disclaims and negates all other warranties, including without limitation, implied warranties or conditions of merchantability, fitness for a particular purpose, or non-infringement of intellectual property or other violation of rights. Further, Search4maid does not warrant or make any representations concerning the accuracy, likely results, or reliability of the use of the materials on its Internet web site or otherwise relating to such materials or on any sites linked to this site.",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w800,
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Text(
              "1. Search4maid is an online platform where employers and domestic helpers can connect and if third party services is needed, such as employment agencies, medical check centers or insurance partners. Search4maid has legal liability with its suggested service and it is up to employers’ choice. Search4maid will NOT process any official paperwork or involved in the creation and processing of any legal contract. All users of this App or website are independent from us and we do not take any responsibility for your communication with other users and any liability arising from using our service.",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w800,
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Text(
              "2. Employers, helpers and agencies should ensure the strict respect of the relevant regulation with each other directly, as well as the negotiation of the domestic helper salary, the employment agency fee and any other charges incurred, in respect with the relevant regulation.",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w800,
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Text(
              "3. All users of this APP or website are independent from us and we do not take any responsibility for your communication with other users and any liability arising from using our service. All data and information shown in the biodata in our App or Website is provided by the applicant. Search4maid is not responsible for any losses and damages caused by any discrepancy and incorrectness of the information and data provided by applicants in the biodata in our App or Website. Clients should verify by themselves the related information during the interviews and screenings. No guarantee for the authenticity of the helpers’ personal data is hereby given by Search4maid.",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w800,
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Text(
              "4. From time to time this APP or website may also include links to other websites. These links are provided for your convenience to provide further information. They do not signify that we endorse the website(s). We have no responsibility for the content of the linked website(s).",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w800,
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Text(
              "5. Search4maid is not responsible for any safety issues occurring while using the services online or meeting users met on the platform offline. We advise all clients to take necessary precautions for personal safety.",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w800,
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Text(
              "6. Agencies are independent from us. It is the agency’s responsibility to make sure their communication with you complies with local regulations.  If you decide to use one of the employment agencies (also called partner agencies) listed on our APP or website, we will not be responsible for any outcome, cost, lost or delay. Ensure that you request all mandatory documents and that the agency has the appropriate license before entering into an agreement with them. Any communication you have with them, is between you and the third party and we will not be liable for any of its outcomes.You must sign a contract with the agency and communicate with them in case of disagreement.",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w800,
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Text(
              "7. Search4maid shall not be held responsible, in case of any damage or cost arising from using our APP or website. Regardless of direct hire or using our partner agency, it is your responsibility to make sure your decisions and actions comply with local regulations.",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w800,
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Text(
              "8. Search4maid does not guarantee that our services will function without errors or interruption. We do not take any liability for problems related to these problems.",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w800,
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Text(
              "9. Search4maid do not take responsibility and disclaim all representations of users in terms of fitness to work, accuracy of provided date and non-infringement.",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w800,
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Text(
              "10. Search4maid shall not be liable to you or others for any special, consequential and punitive damages, incidental, indirect, loss of data, offensive or defamatory wordings.",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w800,
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Text(
              "11. Search4maid strictly recommend to each user to respect the rights and obligations governed by Hong Kong laws. If user is not based in Hong Kong, we strictly recommend to respect the rights and obligations governed by his country.",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w800,
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Text(
              "12. In the unlikely event that we end up in a legal dispute, it will take place in Hong Kong courts, applying Hong Kong law. Regardless of your geographical residential location or where you used our services.",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w800,
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Text(
              "Duration of use",
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.w800,
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Text(
              "1. Helper profiles and employer job post will remain active for 6 months only, unless users has reported to our system that helper/employer has been found (The system will then not show anymore the job/resume in public). Returning members can log in using their old account information. After a standard period of time profiles will be hidden from public view. Users may also do this on their own accord whenever they deem it necessary.",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w800,
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Text(
              "2. Failure to abide by any of our user obligations will result in account closure and banning from the APP or website. We reserve the right to change these rules at any time.",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w800,
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Text(
              "3. If you want to contact us related to these terms, please contact us by email (info@Search4maid.hk) with detailed information on how we can assist you and we will get back to your query as soon we can",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w800,
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Text(
              "Governing Law",
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.w800,
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Text(
              "Any claim relating to Search4maid’s web site or APP shall be governed by the laws of Hong Kong without regard to its conflict of law provisions.",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w800,
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Text(
              "General Terms and Conditions applicable to Use of a Web Site.",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w800,
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Text(
              "Privacy Policy",
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.w800,
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Text(
              "Your privacy is very important to us. Accordingly, we have developed this Policy in order for you to understand how we collect, use, communicate and disclose and make use of personal information. The following outlines our privacy policy.",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w800,
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Text(
              "Before or at the time of collecting personal information, we will identify the purposes for which information is being collected.",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w800,
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Text(
              "We will collect and use of personal information solely with the objective of fulfilling those purposes specified by us and for other compatible purposes, unless we obtain the consent of the individual concerned or as required by law.",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w800,
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Text(
              "We will only retain personal information as long as necessary for the fulfillment of those purposes.",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w800,
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Text(
              "We will collect personal information by lawful and fair means and, where appropriate, with the knowledge or consent of the individual concerned.",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w800,
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Text(
              "Personal data should be relevant to the purposes for which it is to be used, and, to the extent necessary for those purposes, should be accurate, complete, and up-to-date.",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w800,
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Text(
              "We will protect personal information by reasonable security safeguards against loss or theft, as well as unauthorized access, disclosure, copying, use or modification.",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w800,
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Text(
              "We will make readily available to customers information about our policies and practices relating to the management of personal information.",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w800,
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Text(
              "We are committed to conducting our business in accordance with these principles in order to ensure that the confidentiality of personal information is protected and maintained.",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w800,
              ),
            ),
            SizedBox(
              height: 20,
            ),
          ],
        ),
      ),
    );
  }
}
