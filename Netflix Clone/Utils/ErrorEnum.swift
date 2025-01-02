enum ApiError: Error {
    case URL_NOT_FOUND;
    case FAILED_TO_FETCH_DATA;
    case FAILED_TO_LOAD_DATA;
}

enum DBError:Error {
    case FAILED_TO_SAVE
    case FAILED_TO_DELETE
    case FAILED_TO_FETCH_LIST
}
