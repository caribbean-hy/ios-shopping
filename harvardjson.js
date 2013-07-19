// Harvard Course API Reformatter
// Lingliang Zhang
// For Winnie Wu
// 16.07.13

var restler = require('restler');
var fs = require('fs');

var hasNum = /[MuWF]\.,.+[0-9]/;
var escapeCode = /\&#8211;/g;
var dates = /([A-Za-z]{1,2}\.,\s)+/;
var times = /(([0-9]+[\-:]*)+(,\s)*)+/;
var rstrip = /[,\s]+$/;
var orReplace = / or /g;
var once = true;
var debug = 100021; //breakpoint

restler.get('https://api.cs50.net/courses/1.0/courses?output=json').on(
 'complete', function(data) {
    // strange bug with code running multiple times
    if (!once) {
      console.log(data);
    }
    if (once) {
      once = false;
      var outJSON = data;
      for (var i = 0, iLen = data.length; i < iLen; i++) {
        if (i == debug + 1) {
          throw "reached breakpoint";
        }
        //console.log("running iteration", i);
        var input = outJSON[i].meetings.replace(escapeCode, "-").replace(orReplace, ", ");
        //console.log("original input", input);
        var newMeetings = "";
        if (hasNum.test(input)) {
          //console.log("found");
          while (hasNum.test(input)) {
            var dateRes = dates.exec(input);
            var dateVal = dateRes[0];
            if (i == debug) {
              console.log("dateVal", dateVal);
            }
            input = input.slice(dateRes.index).replace(dates, "");
            if (i == debug) {
              console.log("halfstrip", input);
            }
            var timeRes = times.exec(input);
            var timeVal = timeRes[0].replace(rstrip, "");
            if (i == debug) {
              console.log("timeVal", timeVal);
            }
            input = input.slice(timeRes.index).replace(times, "");
            if (i == debug) {
              console.log("stripped input", input);
            }
            var dateArr = dateVal.split("., ");
            if (i == debug) {
              console.log("dateArr", dateArr);
            }
            for (var j=0, jLen = dateArr.length; j < jLen - 1; j++) {
		newMeetings += dateArr[j] + " " + timeVal + " ";              

		}
            }
            //console.log(newMeetings);
          outJSON[i].meetings = newMeetings;
        } else {
          //console.log("no times provided");
          outJSON[i].meetings = "";
        }
      }
      // the javascript object output
      // console.log(outJSON);
      // STDOUt a JSON string
      // console.log(JSON.stringify(outJSON));
      // writing to a file
      fs.writeFile("harvardjson_out.json", JSON.stringify(outJSON));
    }
 });
