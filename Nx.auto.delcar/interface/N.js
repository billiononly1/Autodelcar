document.addEventListener('DOMContentLoaded',function(){const e=document.getElementById('countdown-container'),t=document.getElementById('time-display'),n=document.getElementById('alert-sound');let o;function a(a){let d=a,i,r;e.classList.remove('fade-out'),e.classList.add('fade-in'),e.style.display='flex',n.play(),o=setInterval(function(){i=parseInt(d/60,10),r=parseInt(d%60,10),i=i<10?'0'+i:i,r=r<10?'0'+r:r,t.textContent=i+':'+r,--d<0&&(clearInterval(o),e.classList.remove('fade-in'),e.classList.add('fade-out'),setTimeout(()=>{e.style.display='none'},1e3),fetch(`https://${GetParentResourceName()}/removeVehicles`,{method:'POST'}))},1e3)}function i(){clearInterval(o),e.classList.remove('fade-in'),e.classList.add('fade-out'),setTimeout(()=>{e.style.display='none'},1e3)}window.addEventListener('message',function(e){'startCountdown'===e.data.type?a(e.data.duration):'stopCountdown'===e.data.type&&i()})});
