import { Injectable } from '@angular/core';
import { ApiService } from './api.service';

@Injectable({
  providedIn: 'root'
})
export class AuthenticationService {

  constructor(public apiService: ApiService) { }

  isLogged() {
    if (!this.getAuthenticated()) {
        window.location.assign("/tabs/account");
    }
  }

  setAuthenticated(id: string) {
    sessionStorage.setItem('bookmeIsLogged', "true");
    sessionStorage.setItem('bookmeUser', id);
  }

  removeAuthenticated() {
    sessionStorage.removeItem('bookmeIsLogged');
    sessionStorage.removeItem('bookmeUser');
  }

  getAuthenticated() {
    var data = sessionStorage.getItem('bookmeIsLogged');
    return data;
  }

  getLoggedUser() {
    var data = sessionStorage.getItem('bookmeUser');
    return data;
  }
}
