import { Controller } from "@hotwired/stimulus"
import { enter, leave } from "el-transition"

export default class extends Controller {
  static targets = ["commentsBox"]

  openStaffComments(e) {
   	var classList = this.commentsBoxTarget.classList
    var staffUserId = this.element.dataset.staffUserId
    var csrfToken = document.querySelector("[name='csrf-token']").content
    // 인수인계 박스가 열렸을 때만 보일 때만
    if (classList.contains('opacity-0')) {
      fetch('/staff/staff_comments/mark_as_read', {
        method: 'POST', // *GET, POST, PUT, DELETE, etc.
        mode: 'cors', // no-cors, *cors, same-origin
        cache: 'no-cache', // *default, no-cache, reload, force-cache, only-if-cached
        credentials: 'same-origin', // include, *same-origin, omit
        headers: {
          'Content-Type': 'application/json',
          'X-CSRF-Token': csrfToken
        },
        body: JSON.stringify({ staff_comment: { staff_user_id: staffUserId } }) // body data type must match "Content-Type" header
      })
        .then(response => response.json())
      // .then(data => {
      //   console.log(data.message)
      // })
	}
  }

  checkComment({ params: { id, domId }}) {
    var staffUserId = this.element.dataset.staffUserId
    var path = location.pathname;
    var csrfToken = document.querySelector("[name='csrf-token']").content
    fetch('/staff/staff_comments/' + id.toString() + '/mark_as_checked', {
	    method: 'POST',
      mode: 'cors', // no-cors, *cors, same-origin
      cache: 'no-cache', // *default, no-cache, reload, force-cache, only-if-cached
      credentials: 'same-origin', // include, *same-origin, omit
      headers: {
        'Content-Type': 'application/json',
        'X-CSRF-Token': csrfToken
      },
      body: JSON.stringify({ staff_comment: { staff_user_id: staffUserId } }) // body data type must match "Content-Type" header
    }).then(response => response.json())
      .then(_ => {
        // NOTE: turbo-frame에 있는 내용만을 JS를 이용해서 갱신하려면, 아래와 같은 트릭이 필요함.
        //
        // See https://github.com/hotwired/turbo/issues/202
        var frame = document.querySelector("turbo-frame#staff-comments-with-global-scope");
        var banishingElement = document.getElementById(domId)
        leave(banishingElement).then(() => {
          banishingElement.classList.add('hidden');

          frame.src = null;
          frame.src = path;
          frame.reload();
        })
      })
  }
}
