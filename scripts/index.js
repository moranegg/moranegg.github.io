$( document ).ready(function(){

    $("#includedMenu").load("menu.html");
    $("#includedContent").load("content.html");

    var path = window.location.pathname;
	  if(path != "" || path != "index.html"){
      var sub_path = path.split("#");
      console.log("splitted");
      if(sub_path[1] == "about"){
        console.log(sub_path[1]);
        router.about();
      }
      console.log(sub_path[1]);
    }

})

var router = {
		index: function(){
      $("#includedContent").load("content.html");
		},
		about: function(){
      console.log("router");
      $("#includedContent").load("en/about.html");
		},
		archives: function(){
      $("#includedContent").load("en/archives.html");

      $("#archives_harp").load("en/archives/harp.html");
      $("#archives_photography").load("en/archives/photography.html");
      $("#archives_cinema").load("en/archives/cinema.html");
      $("#archives_ihs").load("en/archives/ihs.html");

		},
		contact: function(){
      $("#includedContent").load("en/contact.html");
		},
    research: function(){
      $("#includedContent").load("en/research.html");
		},
    projects: function(){
      $("#includedContent").load("en/projects.html");
		},
    speaking: function(){
      $("#includedContent").load("en/speaking.html");
		},
}


function show(page){
    var destination = page;
    $("#includedContent").load("en/"+destination+".html");
    return true;
}
