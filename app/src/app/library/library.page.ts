import { Component } from '@angular/core';
import { AuthenticationService } from '../config/authentication.service';
import { ApiService } from '../config/api.service';

@Component({
  selector: 'app-library',
  templateUrl: 'library.page.html',
  styleUrls: ['library.page.scss']
})
export class LibraryPage {

    constructor(public apiService: ApiService, public authenticationService: AuthenticationService) {
        if (!authenticationService.getAuthenticated()) window.location.assign("/tabs/account");
    }

}
