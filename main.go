package main

import (
	"flag"
	"io"
	"log"
	"os"

	"github.com/apache/arrow-go/v18/arrow"
	"github.com/apache/arrow-go/v18/arrow/csv"
	"github.com/apache/arrow-go/v18/parquet"
	"github.com/apache/arrow-go/v18/parquet/pqarrow"
)

func main() {
	inputFile := flag.String("input", "", "Path to the input CSV file")
	outputFile := flag.String("output", "", "Path to the output Parquet file")
	flag.Parse()

	if *inputFile == "" || *outputFile == "" {
		log.Fatalf("Both -input and -output arguments are required")
	}

	csvFile, err := os.Open(*inputFile)
	if err != nil {
		log.Fatalf("Failed to open input CSV file: %v", err)
	}
	defer csvFile.Close()

	csvReader := read_csv(csvFile)

	parquetFile, err := os.Create(*outputFile)

	if err != nil {
		log.Fatalf("Failed to open input Paqrquet file: %v", err)
	}
	defer csvFile.Close()

	write_parquet(parquetFile, csvReader)

	log.Println("Successfully converted CSV to Parquet.")
}

func read_csv(data io.ReadCloser) chan arrow.Record {

	schema := arrow.NewSchema(
		[]arrow.Field{
			{Name: "Name", Type: arrow.BinaryTypes.String},
			{Name: "Age", Type: arrow.PrimitiveTypes.Int32},
			{Name: "Country", Type: arrow.BinaryTypes.String},
		},
		nil,
	)

	csvReader := csv.NewReader(data, schema, csv.WithComma(','), csv.WithHeader(true), csv.WithChunk(500))
	defer csvReader.Release()

	ch := make(chan arrow.Record, 10)
	go func() {
		defer data.Close()
		defer close(ch)
		for csvReader.Next() {
			rec := csvReader.Record()
			rec.Retain()
			ch <- rec
		}

		if csvReader.Err() != nil {
			panic(csvReader.Err())
		}
	}()
	return ch
}

func write_parquet(outfile *os.File, ch chan arrow.Record) {
	rec := <-ch

	props := parquet.NewWriterProperties()
	writer, err := pqarrow.NewFileWriter(rec.Schema(), outfile, props,
		pqarrow.DefaultWriterProps())
	if err != nil {
		panic(err)
	}
	defer writer.Close()

	if err := writer.Write(rec); err != nil {
		panic(err)
	}
	rec.Release()

	for rec := range ch {
		if err := writer.Write(rec); err != nil {
			panic(err)
		}
		rec.Release()
	}
}
