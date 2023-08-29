// import 'package:appinio_video_player/appinio_video_player.dart';
// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
// import '/src/utils/app_utils.dart';
// String longVideo ="assets/images/bg_official_video.mp4";


// class TestimonialVideo extends StatefulWidget {
//   const TestimonialVideo({super.key, required this.height});
//   final double height; 

//   @override
//   State<TestimonialVideo> createState() => _TestimonialVideoState();
// }

// class _TestimonialVideoState extends State<TestimonialVideo> {
  
//   late CustomVideoPlayerController _customVideoPlayerController;
//   late CustomVideoPlayerWebController _customVideoPlayerWebController;

//   final CustomVideoPlayerSettings _customVideoPlayerSettings =
//       const CustomVideoPlayerSettings();
//   late VideoPlayerController _videoPlayerController;
//   final CustomVideoPlayerWebSettings _customVideoPlayerWebSettings =
//       CustomVideoPlayerWebSettings(
//     src: longVideo,
//   );
  
   

//    @override
//   void initState() {
//     super.initState();
    
//     _videoPlayerController = VideoPlayerController.asset(
//       longVideo,
//     )..initialize().then((value) => setState(() {}));

//     _customVideoPlayerController = CustomVideoPlayerController(
//       context: context,
//       videoPlayerController: _videoPlayerController,
//       customVideoPlayerSettings: _customVideoPlayerSettings,
//     );

//     _customVideoPlayerWebController = CustomVideoPlayerWebController(
//       webVideoPlayerSettings: _customVideoPlayerWebSettings,
//     );
//   }

//   @override
//   void dispose() {
//     _customVideoPlayerController.dispose();
//     super.dispose();
//   }

 
//   @override
//   Widget build(BuildContext context) {
//     final size = MediaQuery.of(context).size;
//     return Scaffold(
//       //backgroundColor: AppConstants.appYellowBG,
//       body: SafeArea(
//           child: Container(
//         width: size.width,
//         height: widget.height,
//         decoration: const BoxDecoration(
//             color: AppConstants.appYellowBG,
//             image: DecorationImage(
//                 alignment: Alignment.centerLeft,
//                 fit: BoxFit.fill,
//                 image: AssetImage("assets/images/ic_grid_bg.png"))),
//         child: Column(
//           children: [
//             AppConstants.h_20,
//             Text(
//               "How to activate the card".toUpperCase(),
//               style: GoogleFonts.poppins(
//                   color: AppConstants.appPurpleColor,
//                   fontWeight: FontWeight.w700,
//                   fontSize: 20),
//             ),
//             const Spacer(
//               flex: 3,
//             ),
//             if (kIsWeb && size.width > 750)
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.start,
//                 crossAxisAlignment: CrossAxisAlignment.center,
//                 children: [
//                   AppConstants.w_30,
//                   AppConstants.w_30,
//                   AppConstants.w_30,
//                   vPlayer(size),
//                   const Spacer(
//                     flex: 2,
//                   ),
//                   instructions(size,false),
//                   const Spacer(
//                     flex: 2,
//                   )
//                 ],
//               ),
//             if (size.width < 750) moblFrmt(size),
//             const Spacer(
//               flex: 2,
//             )
//           ],
//         ),
//       )),
//     );
//   }

//   instructions(Size size,bool ismbFmt) {
//     return Padding(
//       padding: const EdgeInsets.all(8.0),
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.start,
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           SizedBox(
//             width:ismbFmt? size.width*0.85:size.width*0.25,
//             child: Text(
//               "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. Lorem Ipsum is simply dummy text of the printing and typesetting industry",
//               maxLines: 10
//               ,style: GoogleFonts.poppins(
//                   color: Colors.black, fontSize: 12, fontWeight: FontWeight.w500),
//             ),
//           ),
//           bulletsPoint(ismbFmt,
//               "Lorem Ipsum is simply dummy text of the printing and typesetting industry.",size),
//           AppConstants.h_5,
//           bulletsPoint(ismbFmt,
//               "Lorem Ipsum is simply dummy text of the printing and typesetting industry.",size),
//           AppConstants.h_5,
//           bulletsPoint(ismbFmt,
//               "Lorem Ipsum is simply dummy text of the printing and typesetting industry.",size),
//           AppConstants.h_5,
//           bulletsPoint(ismbFmt,
//               "Lorem Ipsum is simply dummy text of the printing and typesetting industry.",size),
//           AppConstants.h_5,
//           bulletsPoint(ismbFmt,
//               "Lorem Ipsum is simply dummy text of the printing and typesetting industry.",size),
//           AppConstants.h_5,
//         ],
//       ),
//     );
//   }

//   bulletsPoint(bool ismbFmt,String title,Size size) {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//       children: [
//         AppConstants.w_5,
//          CircleAvatar(
//           radius: 25,
//           backgroundColor: AppConstants.appPurplelit1Color,
//           child: CircleAvatar(
//             radius: 20,
//             backgroundColor: AppConstants.appPurplelit2Color,
//             child: CircleAvatar(
//               radius: 15,
//               backgroundColor: AppConstants.appPurpleColor,
//               child: Container(padding: AppConstants.all_5,child: Image.asset("assets/images/ic_tick.png",)),
//             ),
//           ),
//         ),
//         AppConstants.w_10,
//         SizedBox(
//           width:ismbFmt? size.width*0.80:size.width*0.25,
//           child: Text(
//             title,
//             style: GoogleFonts.poppins(
//                 color: Colors.black, fontSize: 12, fontWeight: FontWeight.w500),
//           ),
//         )
//       ],
//     );
//   }

//   moblFrmt(Size size) {
//     return Column(
//       children: [
//         instructions(size,true),
//         vPlayer(size),
//       ],
//     );
//   }

//   vPlayer(Size size) {
//     return Container(
//       height: size.width < 750 ? size.height * 0.35 : size.height * 0.55,
//       width: size.width < 750 ? size.width * 0.85 : size.width * 0.45,
//       decoration: BoxDecoration(
//           color: Colors.grey.shade200,
//           borderRadius: const BorderRadius.all(Radius.zero)),
//       child: kIsWeb
//                 ? CustomVideoPlayerWeb(
//                       customVideoPlayerWebController:
//                           _customVideoPlayerWebController,
//                     )
//                 : CustomVideoPlayer(
//                     customVideoPlayerController: _customVideoPlayerController,
//                   ),
//     );
//   }
// }
