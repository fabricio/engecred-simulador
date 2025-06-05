import { NextResponse } from 'next/server';
import { getConnection } from '@/lib/db';

export async function GET(request: Request) {
  try {
    const { searchParams } = new URL(request.url);
    const productId = searchParams.get('productId');
    const segmentId = searchParams.get('segmentId');

    const pool = await getConnection();
    let query = `
      SELECT r.*, p.Name as ProductName, p.Modality, p.PersonType,
             s.Code as SegmentCode, s.Name as SegmentName
      FROM Rates r
      INNER JOIN Products p ON r.ProductId = p.Id
      INNER JOIN Segments s ON r.SegmentId = s.Id
    `;

    const request = pool.request();
    if (productId) {
      query += ' WHERE r.ProductId = @productId';
      request.input('productId', productId);
    }
    if (segmentId) {
      query += productId ? ' AND r.SegmentId = @segmentId' : ' WHERE r.SegmentId = @segmentId';
      request.input('segmentId', segmentId);
    }

    query += ' ORDER BY p.PersonType, p.Modality, p.Name, s.MinAnnualIncome';

    const result = await request.query(query);
    return NextResponse.json(result.recordset);
  } catch (error) {
    console.error('Erro ao buscar taxas:', error);
    return NextResponse.json({ error: 'Erro ao buscar taxas' }, { status: 500 });
  }
}