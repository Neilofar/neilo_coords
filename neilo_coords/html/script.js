window.addEventListener('message', (event) => {
const d = event.data
if (!d) return
if (d.action === 'copy' && d.text) {
// attempt to copy to system clipboard
navigator.clipboard && navigator.clipboard.writeText(d.text).then(() => {
// notify back to client
fetch(`https://` + GetParentResourceName() + `/copied`, { method: 'POST', body: JSON.stringify({ success: true }) }).catch(()=>{})
}).catch(() => {
// fallback: create textarea
const ta = document.createElement('textarea')
ta.value = d.text
document.body.appendChild(ta)
ta.select()
document.execCommand('copy')
ta.remove()
fetch(`https://` + GetParentResourceName() + `/copied`, { method: 'POST', body: JSON.stringify({ success: false }) }).catch(()=>{})
})
}
})


// helper to get parent resource name (works in fx)
function GetParentResourceName(){
try{
return window.location.pathname.split('/')[1] || 'tennis_coords'
}catch(e){return 'tennis_coords'}
}