var survey_data = {
	"title" : "First Survey",
		"pages" : [
		{
			"title" : "Page 1",
			"questions" : [
			{
				"question" : "Gender?",
				"type" : "single_choice",
				"answers" : [
					"Female",
					"Male",
					"Don't want to say"
				]
			},
			{
				"question" : "Gender?",
				"type" : "single_choice",
				"other" : "yes",
				"answers" : [
					"Female",
					"Male",
				]
			},
			{
				"question" : "Languages?",
				"type" : "multiple_choice",
				"answers" : [
					"Perl",
					"Javascript",
				]
			},
			{
				"question" : "Technologies?",
				"type" : "multiple_choice",
				"answers" : [
					"Perl",
					"Javascript",
					"JQuery",
					"Dancer",
					"CSS",
					"HTML"
				],
				"other" : "yes",
			},
			{
				"question" : "Technologies in selection?",
				"type" : "multiple_choice",
				"answers" : [
					"Perl",
					"Javascript",
					"JQuery",
					"Dancer",
					"CSS",
					"HTML"
				],
				"other" : "yes",
				"style" : "selection",
			}
			]
		}
		]
};
