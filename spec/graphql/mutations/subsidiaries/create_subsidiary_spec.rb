namespace Subsidiaries
  mutation createSubsidiary($input: SubsidiaryInput!) {
    createSubsidiary(input: $input) {
      id
      name
      status {
        id
        name
      }
      corporation {
        id
        name
      }
    }
  }
