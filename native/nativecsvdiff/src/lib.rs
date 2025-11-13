use csv_diff::diff_row::{ByteRecordLineInfo, DiffByteRecord};
use csv_diff::{csv::Csv, csv_diff::CsvByteDiffLocal};

use rustler::{Binary, Env, NewBinary, NifResult, NifStruct, NifTaggedEnum};

#[rustler::nif]
pub fn diff<'a>(env: Env<'a>, a: &str, b: &str) -> NifResult<Vec<NifDiffByteRecord<'a>>> {
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
        .map(|diff_byte_record| NifDiffByteRecord::new(env, diff_byte_record))
        .collect())
}

#[derive(NifTaggedEnum)]
pub enum NifDiffByteRecord<'a> {
    Add(NifByteRecordLineInfo<'a>),
    Modify {
        delete: NifByteRecordLineInfo<'a>,
        add: NifByteRecordLineInfo<'a>,
        field_indices: Vec<usize>,
    },
    Delete(NifByteRecordLineInfo<'a>),
}

#[derive(NifStruct)]
#[module = "CsvDiff.ByteRecordLineInfo"]
pub struct NifByteRecordLineInfo<'a> {
    pub line: u64,
    pub record: Vec<Binary<'a>>,
}

fn binary_from_slice<'a>(env: Env<'a>, slice: &[u8]) -> Binary<'a> {
    let mut binary = NewBinary::new(env, slice.len());
    binary.as_mut_slice().copy_from_slice(slice);
    binary.into()
}

impl<'a> NifByteRecordLineInfo<'a> {
    fn new(env: Env<'a>, byte_record_line_info: ByteRecordLineInfo) -> Self {
        NifByteRecordLineInfo {
            line: byte_record_line_info.line(),
            record: byte_record_line_info
                .into_byte_record()
                .iter()
                .map(|b| binary_from_slice(env, b))
                .collect(),
        }
    }
}

impl<'a> NifDiffByteRecord<'a> {
    fn new(env: Env<'a>, diff_byte_record: DiffByteRecord) -> Self {
        match diff_byte_record {
            DiffByteRecord::Add(byte_record_line_info) => {
                NifDiffByteRecord::Add(NifByteRecordLineInfo::new(env, byte_record_line_info))
            }
            DiffByteRecord::Modify {
                delete,
                add,
                field_indices,
            } => NifDiffByteRecord::Modify {
                delete: NifByteRecordLineInfo::new(env, delete),
                add: NifByteRecordLineInfo::new(env, add),
                field_indices,
            },
            DiffByteRecord::Delete(byte_record_line_info) => {
                NifDiffByteRecord::Delete(NifByteRecordLineInfo::new(env, byte_record_line_info))
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
