import { Controller } from "stimulus"

export default class extends Controller {
  static targets = [ "image" ]

  checkFileSize() {
    const size_in_megabytes = this.imageTarget.files[0].size/1024/1024;
    if (size_in_megabytes > 5) {
      alert("Maximum file size is 5MB. Please choose a smaller file.");
      this.imageTarget.value = "";
    }
  }
}
