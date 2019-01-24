// read the user login token from a cookie
Shiny.addCustomMessageHandler("readCookie", function(message) {
    var cookie = readCookie();
    Shiny.onInputChange("cookie",cookie);
});

function readCookie() {
  const Http = new XMLHttpRequest();
  const url='https://staging.synapse.org/Portal/sessioncookie';
  Http.withCredentials = true;
  Http.open("GET", url);
  Http.send();
  Http.onreadystatechange=(e)=>{return(Http.responseText)};
}
