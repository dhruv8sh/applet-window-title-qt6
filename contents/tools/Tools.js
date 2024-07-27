function qBound(min,value,max)
{
    return Math.max(Math.min(max, root.width - 150), min);
}
function clean(item)
{
    if (item.length>=2 && item.indexOf('"')===0 && item.lastIndexOf('"')===item.length-1) return item.substring(1, item.length-1);
        else return item;
}
function match(item,target){
    return new RegExp('^'+
        clean(item)
            .replace(/[|\\{}()[\]^$+?]/g, '\\$&')
            .replace(/\*/g, '.*')
        +'$'
    ).test(target)
}
function sub(str){
    return str
        .replace("%a",activeTaskItem.appName)
        .replace("%w",activeTaskItem.title)
        .replace("%q",fullActivityInfo.name)
}
function substitute(inp,override) {
    let minSize = Math.min(cfg.subsMatchApp.length, cfg.subsReplace.length,cfg.subsMatchTitle.length)

    let appName=activeTaskItem.appName, title=activeTaskItem.title
    let text= appName === title ? override ? sub(inp) : sub(cfg.txtSameFound) : sub(inp)

    for(let i=0; i<minSize; i++){
        if(match(cfg.subsMatchApp[i],appName) && match(cfg.subsMatchTitle[i],title)) {
            text = cfg.subsReplace[i]
            console.log("match found")
        }
    }
    return sub(clean(text))
}
function altSubstitute() {
    return cfg.altTxt.replace("%q",fullActivityInfo.name)
}
function getIcon() {
    if(existsWindowActive) return activeTaskItem.icon
    else if(cfg.noIcon) return ""
    else if(cfg.activityIcon) return fullActivityInfo.icon
    else return cfg.customIcon
}
function getElide(val) {
    switch(val) {
        case 0: return Text.ElideNone
        case 1: return Text.ElideLeft
        case 2: return Text.ElideMiddle
        case 3: return Text.ElideRight
    }
}
