// SDPX-License-Identifier: MIT

pragma solidity ^0.6.0;

contract testContract {
    int public id = 0;
    Book[] public books;
    // title to id
    mapping(string => int) title_to_id;

    struct Book {
        int pageNum;
        int id;
        string title;
        string description;
    }

    function create_book(int _pageNum, string memory _title, string memory _description) public {
        Book memory myBook = Book(_pageNum, id, _title, _description);
        books.push(myBook);
        title_to_id[_title] = id;
        id = id + 1;
    }

    function list_book_info(string memory _title) public view returns(int, string memory, string memory) {
        uint256 bookId = uint256(title_to_id[_title]);
        return (books[bookId].pageNum, books[bookId].title, books[bookId].description);
    }

    // creating test data
    function create_test_books() public {
        create_book(50, "coloring book", "first created book :)");
        create_book(120, "Bass fishing tactics", "catch all the fish!!!");
        create_book(600, "Encyclopedia", "idk, has a ton of pages");
    }
}