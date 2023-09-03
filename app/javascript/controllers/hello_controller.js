import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
    this.element.textContent = "Hello World!"
  }

  handleClick() {
    this.element.textContent = "Hello Stimulus!"
  }
}
