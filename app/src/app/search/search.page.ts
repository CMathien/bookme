import { Component } from '@angular/core';
import { ApiService } from '../config/api.service';
import { AuthenticationService } from '../config/authentication.service';

@Component({
  selector: 'app-search',
  templateUrl: 'search.page.html',
  styleUrls: ['search.page.scss']
})
export class SearchPage {

    book :any = {} ;
    result: boolean = false;
    isLogged: string | null;

    constructor(public apiService: ApiService, public authenticationService: AuthenticationService) {
        this.isLogged = authenticationService.getAuthenticated();
    }

    search(event: any){
        let value: string = event.target.value;

        this.apiService.apiFetchOL(value, "get", (res: any) => {
            if (res) {
                let obj = res["ISBN:"+value];
                if (obj) {
                    let img_url = obj.thumbnail_url;
                    img_url = img_url.substring(0, img_url.length - 5);
                    img_url += "M.jpg";
                    this.book.img = img_url;
                    this.book.title = obj.details.title;
                    let isbns = obj.details.isbn_13;
                    let clean_isbns: Array<string> = [];
                    isbns.forEach(function(element: string) {
                        let code_1 = element.slice(0, 3);
                        let code_2 = element.slice(3, 4);
                        let code_3 = element.slice(4, 7);
                        let code_4 = element.slice(7, 12);
                        let code_5 = element.slice(12);
                        let new_isbn= code_1 + "-" + code_2 + "-" + code_3 + "-" + code_4 + "-" + code_5;;
                        clean_isbns.push(new_isbn);
                    });
                    this.book.isbns = clean_isbns;
                    this.book.publishDate = obj.details.publish_date;
                    this.book.authors = obj.details.authors;
                    this.book.publishers = obj.details.publishers;
                    this.result = true;
                } else this.result = false;
            } else this.result = false;
        })
    }

    numberOnlyValidation(event: any) {
        const pattern = /[0-9]/;
        let inputChar = String.fromCharCode(event.charCode);
    
        if (!pattern.test(inputChar)) {
          event.preventDefault();
        }
      }
}
