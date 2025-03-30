import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["button", "text"]

  copy(event) {
    event.preventDefault()
    const text = this.textTarget.innerText.trim()
    navigator.clipboard.writeText(text).then(() => {
      this.buttonTarget.textContent = "Copied!"
       
      setTimeout(() => {
        this.buttonTarget.textContent = "Copy text"
      }, 2000)
    })
  }
} 