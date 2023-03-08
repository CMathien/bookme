import { Component, OnInit } from '@angular/core';
import { AuthenticationService } from '../config/authentication.service';
import { ApiService } from '../config/api.service';

@Component({
  selector: 'app-donations',
  templateUrl: './donations.page.html',
  styleUrls: ['./donations.page.scss'],
})
export class DonationsPage implements OnInit {

    constructor(public apiService: ApiService, public authenticationService: AuthenticationService) {
        if (!authenticationService.getAuthenticated()) window.location.assign("/tabs/account");
    }

  ngOnInit() {
  }

}
