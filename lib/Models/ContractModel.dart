import 'package:cloud_firestore/cloud_firestore.dart';

class ContractContext {
  final String agency_id;
  final String contract_type;
  final DateTime created_at;
//  final String created_at;
  final String created_by;
  final String current_status;
  final String employer_id;
  String id;
  final String img_receipt;
  final String profile_id;
  final String contract_id;


  ContractContext({
    this.agency_id,
    this.contract_type,
    this.created_at,
    this.created_by,
    this.current_status,
    this.employer_id,
    this.id,
    this.img_receipt,
    this.profile_id,
    this.contract_id,
  });

  factory ContractContext.fromMap(Map<String, dynamic> data,
      String documentId) =>
      ContractContext(
        agency_id: data["agency_id"],
        contract_type: data["contract_type"],
        created_at: data["created_at"],
        created_by: data["created_by"],
        current_status: data["current_status"],
        employer_id: data["employer_id"],
        id: data["id"],
        img_receipt: data["img_receipt"],
        profile_id: data["profile_id"],
        contract_id: data["contract_id"],
      );

  Map<String, dynamic> toMap() =>
      {
        "agency_id": agency_id,
        "contract_type": contract_type,
        "created_at": created_at,
        "created_by": created_by,
        "current_status": current_status,
        "employer_id": employer_id,
        "id": id,
        "img_receipt": img_receipt,
        "profile_id": profile_id,
        "contract_id": contract_id,
      };

}