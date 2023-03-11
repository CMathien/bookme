import { TestBed } from '@angular/core/testing';

import { BarcodescannerService } from './barcodescanner.service';

describe('BarcodescannerService', () => {
  let service: BarcodescannerService;

  beforeEach(() => {
    TestBed.configureTestingModule({});
    service = TestBed.inject(BarcodescannerService);
  });

  it('should be created', () => {
    expect(service).toBeTruthy();
  });
});
