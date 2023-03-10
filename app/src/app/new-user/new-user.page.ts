import { Component } from '@angular/core';
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
    canSubmit: boolean;
    errorMsg: string;
    emailExists: boolean;
    pseudoExists: boolean;

    constructor(public apiService: ApiService) {
        this.newUserForm = new FormGroup({
            email: new FormControl('', [Validators.required, Validators.pattern('[a-z0-9._%+-]+@[a-z0-9.-]+\.[a-z]{2,3}$')]),
            password: new FormControl("", [Validators.required]),
            passwordControl: new FormControl("", [Validators.required]),
            pseudo: new FormControl("", [Validators.required]),
            zipcode: new FormControl("", [Validators.required])
        });
        this.wrongPwd = false;
        this.noCorresPwd = false;
        this.canSubmit = false;
        this.emailExists = false;
        this.pseudoExists = false;
        this.errorMsg = "";
    }

    ngOnInit() {
        this.loadForm();
    }

    loadForm() {
        this.newUserForm = new FormGroup({
            email: new FormControl('', [Validators.required, Validators.pattern('[a-z0-9._%+-]+@[a-z0-9.-]+\.[a-z]{2,3}$')]),
            password: new FormControl("", [Validators.required]),
            passwordControl: new FormControl("", [Validators.required]),
            pseudo: new FormControl("", [Validators.required]),
            zipcode: new FormControl("", [Validators.required])
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
        let pseudo = this.newUserForm.value.pseudo;
        let zipcode = this.newUserForm.value.zipcode;
        let city = "";

        this.createLocation(zipcode, city);
        interface BodyUser {
            email: string;
            password: string;
            pseudo: string,
            avatar: string,
            publicComments: boolean,
            balance: number,
            admin: boolean,
            banned : boolean,
            zipCode: string
        }

        let bodyUser: BodyUser = {
            email: email,
            password: password,
            pseudo: pseudo,
            avatar: "null",
            publicComments: true,
            balance: 5,
            admin: false,
            banned : false,
            zipCode: zipcode
        };

        this.createUser(bodyUser);
    }

    controlPassword(){
        let password = this.newUserForm.value.password;

        if (/^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)[a-zA-Z\d]{8,}$/.test(password) === false) {
            this.wrongPwd = true;
        } else {
            this.wrongPwd = false;
        }

        this.control();
    }

    comparePassword(){
        let password = this.newUserForm.value.password;
        let passwordControl = this.newUserForm.value.passwordControl;
        if (password !== passwordControl) {
            this.noCorresPwd = true;
        }
        else {
            this.noCorresPwd = false;
        }
        this.control();
    }

    control() {
        console.log(this.wrongPwd, this.noCorresPwd, !this.newUserForm.valid, this.emailExists, this.pseudoExists);
        if (this.wrongPwd === true) this.canSubmit = false;
        else if (this.noCorresPwd === true) this.canSubmit = false;
        else if (!this.newUserForm.valid) this.canSubmit = false;
        else if (this.emailExists === true) this.canSubmit = false;
        else if (this.pseudoExists === true) this.canSubmit = false;
        else this.canSubmit = true;
    }

    createLocation(zipcode: string, city: string) {
        this.apiService.apiFetch(`/zipcodes/${zipcode}`, "get", (res: any) => {
            if (res.status !== "ZIPCODE_GET") {
                interface BodyZipCode {
                    zipcode: string
                }
        
                let bodyZipCode: BodyZipCode = {
                    zipcode: zipcode
                };
        
                this.apiService.apiBodyFetch("/zipcodes", "post", (res: any) => {
                    // if (res.status === "ZIPCODE_CREATED") {
                    //     interface BodyCity {
                    //         name: string,
                    //         country: number
                    //     }
        
                    //     let bodyCity: BodyCity = {
                    //         name: city,
                    //         country: 65
                    //     };
        
                    //     this.apiService.apiBodyFetch("/cities", "post", (res: any) => {
                    //         if (res.status === "CITY_CREATED") {
                    //             let body = {
                    //                 city_id: res.data["id"]
                    //             }
                    
                    //             this.apiService.apiBodyFetch(`/zipcodes/${zipcode}/link`, "post", (res: any) => {
                    //                 if (res.status !== "SUCCESS") {
                    //                     this.errorMsg = res.message;
                    //                 }
                    //             }, body);
                    //         } else {
                    //             this.errorMsg = res.message;
                    //         }
                    //     }, bodyCity);
                    // } else {
                    //     this.errorMsg = res.message;
                    // }
                }, bodyZipCode);
            }
        });
        
    }

    createUser(body: any) {
        this.apiService.apiBodyFetch("/users", "post", (res: any) => {
            if (res.status === "USER_CREATED") {
                window.location.assign("tabs/account");
            } else {
                this.errorMsg = res.message;
            }
        }, body);
    }

    controlEmail() {
        let email = this.newUserForm.value.email;
        let body = {
            email: email
        };
        this.apiService.apiBodyFetch("/users/email", "post", (res: any) => {
            if (res.count > 0) {
                this.emailExists = true;
            } else {
                this.emailExists = false;
            }
            this.control();
        }, body);
    }

    controlPseudo() {
        let pseudo = this.newUserForm.value.pseudo;
        let body = {
            pseudo: pseudo
        };
        this.apiService.apiBodyFetch("/users/pseudo", "post", (res: any) => {
            if (res.count > 0) {
                this.pseudoExists = true;
            } else {
                this.pseudoExists = false;
            }
            this.control();
        }, body);
    }
}
