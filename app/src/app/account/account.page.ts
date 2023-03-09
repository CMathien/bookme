import { Component } from '@angular/core';
import { AuthenticationService } from '../config/authentication.service';
import { ApiService } from '../config/api.service';
import {FormControl, FormGroup, Validators} from '@angular/forms';


@Component({
  selector: 'app-account',
  templateUrl: 'account.page.html',
  styleUrls: ['account.page.scss']
})
export class AccountPage {
    isLogged: string | null;
    user: any | null;
    loginForm: FormGroup;


    constructor(public authenticationService: AuthenticationService, public apiService: ApiService) {
        this.loginForm = new FormGroup({
            email: new FormControl(),
            password: new FormControl()
        });
        this.isLogged = authenticationService.getAuthenticated();

        if (this.isLogged === "true") {
            let id = authenticationService.getLoggedUser();
            this.apiService.apiFetch(`/users/${id}`, "get",  (res: any) => {
                let tmp = res.data;
                this.user = {
                    pseudo: tmp["pseudo"],
                    email: tmp["email"],
                    publicComments: tmp["publicComments"],
                    balance: tmp["balance"],
                    zipcode: tmp["zipcode"]["zipcode"],
                }
            })
        }

    }
    ngOnInit(): void {
        if (this.isLogged !== "true") this.setupLoginForm();
    }

    setupLoginForm() {
        this.loginForm = new FormGroup({
            email: new FormControl('', [Validators.required, Validators.pattern('[a-z0-9._%+-]+@[a-z0-9.-]+\.[a-z]{2,3}$')]),
            password: new FormControl("", [Validators.required])
          });
    }

    submitLogin() {
        let email = this.loginForm.value.email;
        let password = this.loginForm.value.password;

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
                this.setLogin(res.id);
            }
        }, body);
    }

    setLogin(id: any) {
        this.authenticationService.setAuthenticated(id);
        window.location.assign("/tabs/home");
    }

    logout() {
        this.authenticationService.removeAuthenticated();
        window.location.assign("/tabs/account");
    }

}
