/*
var protoClasses = ["Layer", "Geometry", "Point", "Size", "Rect"]

$("h4").each(function(i, e){
    var defn = e.innerHTML;
    protoClasses.forEach(function(className){
        var classRe = new RegExp('\\b'+className+'\\s*\\b', 'g');
        var matched = classRe.test(defn);
        if (matched) {
            console.log(className, defn)
        }
    })
})
*/

var Language = {
	Swift: "Swift",
	JavaScript: "JavaScript"
}

var languageKey = "language"
var defaultLanguage = Language.JavaScript
var currentLanguage = localStorage.getItem(languageKey) || defaultLanguage
updateStylesForLanguage()

function setLanguage(language) {
	currentLanguage = language
	localStorage.setItem(languageKey, language)
	updateStylesForLanguage()
}

function updateStylesForLanguage() {
	var classList = document.body.classList
	switch (currentLanguage) {
	case Language.Swift:
		classList.remove("javascript")
		classList.add("swift")
		break
	case Language.JavaScript:
		classList.add("javascript")
		classList.remove("swift")
		break
	default:
		throw "Unknown language " + currentLanguage
	}
}

