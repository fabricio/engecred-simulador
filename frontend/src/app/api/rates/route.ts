import { NextResponse } from 'next/server';
import db from '@/lib/db';

export async function GET(request: Request) {
  try {
    const { searchParams } = new URL(request.url);
    const productId = searchParams.get('productId');
    const segmentId = searchParams.get('segmentId');

    let query = `
      SELECT r.*, p.Name as ProductName, p.Modality, p.PersonType,
             s.Code as SegmentCode, s.Name as SegmentName
      FROM Rates r
      INNER JOIN Products p ON r.ProductId = p.Id
      INNER JOIN Segments s ON r.SegmentId = s.Id
    `;

    const params: string[] = [];
    if (productId) {
      query += ' WHERE r.ProductId = ?';
      params.push(productId);
    }
    if (segmentId) {
      query += productId ? ' AND r.SegmentId = ?' : ' WHERE r.SegmentId = ?';
      params.push(segmentId);
    }

    query += ' ORDER BY p.PersonType, p.Modality, p.Name, s.MinAnnualIncome';

    const rates = db.prepare(query).all(...params);
    return NextResponse.json(rates);
  } catch (error) {
    console.error('Erro ao buscar taxas:', error);
    return NextResponse.json({ error: 'Erro ao buscar taxas' }, { status: 500 });
  }
}