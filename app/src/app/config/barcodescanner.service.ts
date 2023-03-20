import { Injectable } from '@angular/core';
import { BarcodeScanner } from '@capacitor-community/barcode-scanner';

@Injectable({
  providedIn: 'root'
})

export class BarcodescannerService {

    qrCodeString = 'This is a secret qr code message';
    scannedResult: any;
    content_visibility = '';
    constructor() {}

    async checkPermission() {
        try {
            const status = await BarcodeScanner.checkPermission({ force: true });
            if (status.granted) {
                return true;
            }
            return false;
        } catch(e) {
            console.log(e);
            return false;
        }
    }

    async scan() {
        try {
            const permission = await this.checkPermission();
            if(!permission) {
                return;
            }
            await BarcodeScanner.hideBackground();
            document.querySelector('body')?.classList.add('scanner-active');
            this.content_visibility = 'hidden';
            const result = await BarcodeScanner.startScan();
            BarcodeScanner.showBackground();
            document.querySelector('body')?.classList.remove('scanner-active');
            this.content_visibility = '';
            if(result?.hasContent) {
                this.scannedResult = result.content;
                return this.scannedResult;
            }
        } catch(e) {
            console.log(e);
            this.stopScan();
        }
    }
    
    stopScan() {
        BarcodeScanner.showBackground();
        BarcodeScanner.stopScan();
        document.querySelector('body')?.classList.remove('scanner-active');
        this.content_visibility = '';
    }

    ngOnDestroy(): void {
        this.stopScan();
    }
}
