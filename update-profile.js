const fs = require('fs');
const path = require('path');
const dir = 'd:/DuAn1_SD21301/project-productmanagement/Project1-SD21301/src/main/webapp/WEB-INF/views/admin';
const rep = `<div class="profile-pill">
                    <span class="profile-avatar-mini">\${sessionScope.loggedInUser != null ? sessionScope.loggedInUser.fullName.substring(0, 1).toUpperCase() : 'U'}</span>
                    <span>\${sessionScope.loggedInUser != null ? sessionScope.loggedInUser.fullName : 'Hệ thống'}</span>
                </div>`;
function walk(d) {
    let files = [];
    fs.readdirSync(d).forEach(f => {
        let p = path.join(d, f);
        if (fs.statSync(p).isDirectory()) {
            files = files.concat(walk(p));
        } else if (p.endsWith('.jsp')) {
            files.push(p);
        }
    });
    return files;
}
let count = 0;
walk(dir).forEach(f => {
    let content = fs.readFileSync(f, 'utf8');
    let newContent = content.replace(/<div class="profile-pill">[\s\S]*?<\/div>/, rep);
    if (content !== newContent) {
        fs.writeFileSync(f, newContent, 'utf8');
        count++;
    }
});
console.log('Updated ' + count + ' files');
