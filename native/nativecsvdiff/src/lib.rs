use csv_diff::diff_row::{ByteRecordLineInfo, DiffByteRecord};
use csv_diff::{csv::Csv, csv_diff::CsvByteDiffLocal};

use rustler::{NifResult, NifStruct, NifTaggedEnum};

#[rustler::nif]
pub fn diff(a: &str, b: &str) -> NifResult<Vec<NifDiffByteRecord>> {
    let csv_byte_diff = CsvByteDiffLocal::new().map_err(|e| {
        rustler::Error::Term(Box::new(format!("error_creating_csv_byte_diff: {}", e)))
    })?;

    let diff_byte_records = csv_byte_diff
        .diff(
            Csv::with_reader_seek(a.as_bytes()),
            Csv::with_reader_seek(b.as_bytes()),
        )
        .map_err(|e| rustler::Error::Term(Box::new(format!("error_diffing_csv: {}", e))))?;

    Ok(diff_byte_records
        .into_iter()
        .map(NifDiffByteRecord::from)
        .collect())
}

#[derive(NifTaggedEnum)]
pub enum NifDiffByteRecord {
    Add(NifByteRecordLineInfo),
    Modify {
        delete: NifByteRecordLineInfo,
        add: NifByteRecordLineInfo,
        field_indices: Vec<usize>,
    },
    Delete(NifByteRecordLineInfo),
}

#[derive(NifStruct)]
#[module = "CsvDiff.ByteRecordLineInfo"]
pub struct NifByteRecordLineInfo {
    pub line: u64,
    pub record: Vec<Vec<u8>>,
}

impl From<ByteRecordLineInfo> for NifByteRecordLineInfo {
    fn from(byte_record_line_info: ByteRecordLineInfo) -> Self {
        NifByteRecordLineInfo {
            line: byte_record_line_info.line(),
            record: byte_record_line_info
                .into_byte_record()
                .iter()
                .map(|b| b.to_vec())
                .collect(),
        }
    }
}

impl From<DiffByteRecord> for NifDiffByteRecord {
    fn from(diff_byte_record: DiffByteRecord) -> Self {
        match diff_byte_record {
            DiffByteRecord::Add(byte_record_line_info) => {
                NifDiffByteRecord::Add(byte_record_line_info.into())
            }
            DiffByteRecord::Modify {
                delete,
                add,
                field_indices,
            } => NifDiffByteRecord::Modify {
                delete: delete.into(),
                add: add.into(),
                field_indices,
            },
            DiffByteRecord::Delete(byte_record_line_info) => {
                NifDiffByteRecord::Delete(byte_record_line_info.into())
            }
        }
    }
}
/*
assert_eq!(
    diff_byte_rows,
    &[DiffByteRecord::Modify {
        delete: ByteRecordLineInfo::new(
            csv::ByteRecord::from(vec!["2", "strawberry", "fruit"]),
            3
        ),
        add: ByteRecordLineInfo::new(csv::ByteRecord::from(vec!["2", "strawberry", "nut"]), 3),
        field_indices: vec![2]
    }]
);
Ok(()){}
*/

rustler::init!("Elixir.CsvDiff.Native");
