/*!
 * Copyright 2010, Gabor Szabo http://szabgab.com/
 * Tripple licensed under the MIT, Artistic 1 or GPL Version 2 licenses.
 * http://jquery.org/license
 * http://perl.org/

 * Supportted survey types:
 * single_choice, multiple_choice
 * Supported options:
 *     "other" : "yes"
 * Styles: 
 *   single_choice  
 *        default: radio buttons
 *   multiple_choice 
 *        default: checkboxes
 * 
 * Tested with jquery 1.4.2
 * TODO support style: <select> for both single_choice and multiple_choice
 */

$(function() { 
//	setTimeout(show_survey, 2000);

	try {
		show_survey(survey_data);
	}
	catch(e) {
		if(e) {
			show(e);
		}
	}

	$("#submit").click(function(){ 
		var result = '';
		// TODO collect result from
		//survey-form
		alert("TODO: checking, collecting and sending results");
	});
});


function show_survey(survey) {
	var text = '<form action="http://example.com/" method="GET" id="survey-form">';
	if (! survey["title"]) {
		throw("Missing survey title");
	}
	
	text += "<h1>" + survey["title"] + "</h1>";
	for(i in survey["pages"]) {
		text += create_page(i, survey["pages"][i]);
	}

	text += '<div id="survey-button"><input type="button" id="submit" value="Send"></div>';
	text += '</form>';

//	alert(text);
	show(text);
	return;
}
function show(text) {
	var now = new Date;
	$("#survey").append(text);
	$("#now").append("" + now);
	return;
}

function create_page(pid, page) {
	var text = "";
	text += '<div class="survey-page-header">' + page["title"] + "</div>";
	for (j in page["questions"]) {
		text += create_question(pid, j, page["questions"][j]);
	}
	return text;
}

function create_question(pid, qid, q) {
	var text = "";
	text += "<h2>" + q["question"] + "</h2>";
	if (q["type"] == "single_choice") {
		text += '<ul>';
		for (a in q["answers"]) {
			text += sprintf('<li><input type="radio" name="%s" value="%s" />%s</li>', [pid + "_" + qid, pid + "_" + qid + "_" + a, q["answers"][a]]);
		}
		if (q["other"] == "yes") {
			text += sprintf('<li><input type="radio" name="%s" value="%s" />%s', [pid + "_" + qid, pid + "_" + qid + "_" + a, "Other"]); 
			// TODO this textbox should only be enabled (or visible) if the user selects "Other"
			text += sprintf(' <input name="%s" size="40" />', [pid + "_" + qid + "_" + a]);
			text += '</li>';
		}
		text += '</ul>';
	} else if (q["type"] == "multiple_choice") {
		if (!q["style"]) {
			q["style"] = "default";
		}
		if (q["style"] == "selection") {
			text += sprintf('<select id="%s">', [pid + "_" + qid]);
			text += '<option></option>';
			for (a in q["answers"]) {
				text +=  sprintf('<option value="%s">%s</option>', 
					[pid + "_" + qid + "_" + a, q["answers"][a]]);
			}
			if (q["other"] == "yes") {
				text +=  sprintf('<option value="%s">%s</option>', 
					[pid + "_" + qid + "_" + a, "Other"]);
			}
			text += "</select>";
			if (q["other"] == "yes") {
				text += sprintf(' <input name="%s" size="40" />', [pid + "_" + qid + "_other"]);
			}
			
			//alert(text);
		} else if (q["style"] == "default") {
			text += '<ul>';
			for (a in q["answers"]) {
				text += sprintf('<li><input type="checkbox" name="%s" value="%s" />%s</li>', 
					[pid + "_" + qid, pid + "_" + qid + "_" + a, q["answers"][a]]);
			}
			if (q["other"] == "yes") {
				text += sprintf('<li><input type="checkbox" name="%s" value="%s" />%s', 
					[pid + "_" + qid, pid + "_" + qid + "_" + a, "Other"]); 
				text += sprintf(' <input name="%s" size="40" />', [pid + "_" + qid + "_other"]);
				text += "</li>";
			}
			text += '</ul>';
		} else {
			throw(sprintf("Invalid style '%s'", [ q["style"] ]));
		}

		// TODO the other textbox should only be enabled (or visible) if the user selects "Other"
		// TODO what if one of the values is other?

	} else {
		throw(sprintf("Invalid question type '%s' in question '%s'", [q["type"], q["question"]]));
	}
	return text;
}

function sprintf(s, a) {
	for (i in a) {
		s = s.replace(/\%s/, a[i]);
	}
	return s;
}
