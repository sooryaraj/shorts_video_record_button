# shorts_video_record_button

Our package provides a stylish and modern video recording button that closely resembles the familiar design seen in popular social media platforms like Instagram.


> Instagram-style video recording button

    RecordButton(  
      showLabel: true,  
      labelColor: Colors.black12,  
      trackColor: Colors.grey.shade300,  
      fillColor: Colors.deepOrange,  
      buttonColor: Colors.transparent,  
      gradients: const [  
        Color(0xff405de6),  
        Color(0xff5851db),  
        Color(0xff833ab4),  
        Color(0xffc13584),  
        Color(0xffe1306c),  
        Color(0xfffd1d1d),  
      ],  
      onPlay: () {  
        // Do whatever you want after play
      },  
      onStop: (int value) {  
        // Do whatever you want after stop
      },  
      onComplete: (int value) {  
        // Do whatever you want after complete
      },  
      seconds: 30,  
    );
