document.getElementById('preview').onchange=function(){
    const text = document.getElementById("write-area").value
    const preview = document.getElementById("preview-area")
    const obj = {text: text};
    const method = "POST";
    const body = JSON.stringify(obj);
    const headers = {
        'Accept': 'application/json',
        'Content-Type': 'application/json'
    };
    fetch("/documents/api_markdown", {method, headers, body}).then((res)=> res.json()).then((obj) => {preview.innerHTML=obj.text}).catch(console.error);
}