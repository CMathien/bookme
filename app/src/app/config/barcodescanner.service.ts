import { Injectable } from '@angular/core';
import { BarcodeScanner } from '@capacitor-community/barcode-scanner';

@Injectable({
  providedIn: 'root'
})

export class BarcodescannerService {

  constructor() {}

  async scan() {

    // Check camera permission
    // This is just a simple example, check out the better checks below
    await BarcodeScanner.checkPermission({ force: true });

    // make background of WebView transparent
    // note: if you are using ionic this might not be enough, check below
    document.body.classList.add("qrscanner");
    BarcodeScanner.hideBackground();
    document.body.classList.remove("qrscanner");

    const result = await BarcodeScanner.startScan(); // start scanning and wait for a result

    // if the result has content
    if (result.hasContent) {
        return result.content; // log the raw scanned content
    } else {
        return false;
    }
  }

}
