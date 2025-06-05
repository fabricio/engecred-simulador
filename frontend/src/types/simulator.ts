export type Segment = {
    Id: number;
    Code: string;
    Name: string;
    PersonType: 'PF' | 'PJ';
    MinAnnualIncome: number;
  };
  
  export type Product = {
    Id: number;
    Name: string;
    PersonType: 'PF' | 'PJ';
    Modality: 'Pre-fixado' | 'Pos-fixado';
  };
  
  export type Rate = {
    Id: number;
    ProductId: number;
    SegmentId: number;
    Rate: number | null;
    ProductName: string;
    Modality: string;
    PersonType: string;
    SegmentCode: string;
    SegmentName: string;
  };
  
  export type Result = {
    segment: string;
    segmentCode: string;
    rate: number | null;
    error: string | null;
  } | null;