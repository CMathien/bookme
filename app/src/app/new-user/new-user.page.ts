import { Component, OnInit } from '@angular/core';
import { ApiService } from '../config/api.service';
import {FormControl, FormGroup, Validators} from '@angular/forms';

@Component({
  selector: 'app-new-user',
  templateUrl: './new-user.page.html',
  styleUrls: ['./new-user.page.scss'],
})

export class NewUserPage {
    newUserForm: FormGroup;
    wrongPwd: boolean;
    noCorresPwd: boolean;
  constructor(public apiService: ApiService) {
    this.newUserForm = new FormGroup({
        email: new FormControl('', [Validators.required, Validators.pattern('[a-z0-9._%+-]+@[a-z0-9.-]+\.[a-z]{2,3}$')]),
        password: new FormControl("", [Validators.required]),
        passwordControl: new FormControl("", [Validators.required]),
        pseudo: new FormControl("", [Validators.required]),
        zipcode: new FormControl("", [Validators.required]),
        city: new FormControl("", [Validators.required])
      });
      this.wrongPwd = false;
      this.noCorresPwd = false;
   }

  ngOnInit() {
    this.newUserForm = new FormGroup({
        email: new FormControl('', [Validators.required, Validators.pattern('[a-z0-9._%+-]+@[a-z0-9.-]+\.[a-z]{2,3}$')]),
        password: new FormControl("", [Validators.required]),
        passwordControl: new FormControl("", [Validators.required]),
        pseudo: new FormControl("", [Validators.required]),
        zipcode: new FormControl("", [Validators.required]),
        city: new FormControl("", [Validators.required])
      });
  }

  numberOnlyValidation(event: any) {
    const pattern = /[0-9]/;
    let inputChar = String.fromCharCode(event.charCode);

    if (!pattern.test(inputChar)) {
      event.preventDefault();
    }
  }

  submitUser() {
    let email = this.newUserForm.value.email;
    let password = this.newUserForm.value.password;
    let passwordControl = this.newUserForm.value.passwordControl;
    let pseudo = this.newUserForm.value.pseudo;
    let zipcode = this.newUserForm.value.zipcode;
    let city = this.newUserForm.value.city;

    interface BodyLogin {
        email: string;
        password: number;
    }

    let body: BodyLogin = {
        email: email,
        password: password,
      };

    this.apiService.apiBodyFetch("/users/login", "post", (res: any) => {
        if (res.status === "AUTHORIZED LOGIN") {
            // this.setLogin(res.id);
        }
    }, body);
}

controlPassword(event: any){
    // $uppercase = preg_match('@[A-Z]@', $password) === 1;
    // $lowercase = preg_match('@[a-z]@', $password) === 1;
    // $number = preg_match('@[0-9]@', $password) === 1;

    // return ($uppercase && $lowercase && $number && strlen($password) >= 8);
}
comparePassword(event: any){
    let password = this.newUserForm.value.password;
    let passwordControl = this.newUserForm.value.passwordControl;
    console.log(password,passwordControl)
}

}
