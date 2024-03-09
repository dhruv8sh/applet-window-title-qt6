const defaultIconName = "kde-symbolic";

function qBound(min,value,max)
{
    return Math.max(Math.min(max, root.width - 150), min);
}

function cleanStringListItem(item)
{
    //console.log(item + " * " + item.length + " * " + item.indexOf('"') + " * " + item.lastIndexOf('"'));
    if (item.length>=2 && item.indexOf('"')===0 && item.lastIndexOf('"')===item.length-1) {
        return item.substring(1, item.length-1);
    } else {
        return item;
    }
}

function applySubstitutes(pat,name,windowtitle)
{
    var minSize = Math.min(plasmoid.configuration.subsMatch.length, plasmoid.configuration.subsReplace.length);
    let text = pat.replace("%a",name).replace("%w",windowtitle);
    for (var i = 0; i<minSize; ++i){
        var fromS = cleanStringListItem(plasmoid.configuration.subsMatch[i]);
        var toS = cleanStringListItem(plasmoid.configuration.subsReplace[i]);
        var regEx = new RegExp(fromS, "ig"); //case insensitive
        text = text.replace(regEx,toS).replace("%a",name).replace("%w",windowtitle);
    }

    return text;
}
